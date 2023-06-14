import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  String _nfcData = '';
  bool _nfcEnabled = false;

  Future<void> checkNFC() async {
    try {
      var availability = await FlutterNfcKit.nfcAvailability;
      debugPrint('Device can Scan NFC');
      setState(() {
        _nfcEnabled = (availability == NFCAvailability.available);
      });
    } catch (e) {
      setState(() {
        _nfcEnabled = false;
      });
    }
  }

  Future<void> _startNFC() async {
    try {
      var tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );
      print('Response from Tag ${jsonEncode(tag)}');

      if (tag.ndefAvailable!) {
        final decodedRecords = await FlutterNfcKit.readNDEFRecords(cached: false);
        if (decodedRecords.isNotEmpty) {
          final firstRecord = decodedRecords.first;
          final payload = utf8.decode(firstRecord.payload as List<int>);
          debugPrint('Payload: $payload');
          setState(() {
            _nfcData = payload;
          });
        }

        final rawRecords = await FlutterNfcKit.readNDEFRawRecords(cached: false);
        for (var record in rawRecords) {
          debugPrint(jsonEncode(record).toString());
        }
      }

      await FlutterNfcKit.finish(iosAlertMessage: "Success");
    } on PlatformException {
      // Handle exceptions if necessary
    }
  }

  Future<void> _startScan() async {
    setState(() {
      _nfcData = 'Scanning NFC Tag...';
    });
    await _startNFC();
  }

  void _showNFCEnableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('NFC is disabled'),
          content: Text('Please enable NFC in your device settings.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkNFC();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scanned NFC Data:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(_nfcData),
            ElevatedButton(
              onPressed: _nfcEnabled ? _startScan : _showNFCEnableDialog,
              child: const Text('Start Scanning'),
            ),
          ],
        ),
      ),
    );
  }
}

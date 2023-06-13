import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:permission_handler/permission_handler.dart';


class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  String _nfcData = '';

  Future<void> _checkNFC() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
    }
  }

  Future<void> _startNFC() async {
    try {
      var tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );
      print(jsonEncode(tag));

      if (tag.ndefAvailable!) {
        // Decoded NDEF records
        final decodedRecords = await FlutterNfcKit.readNDEFRecords(cached: false);
        for (var record in decodedRecords) {
          print(record.toString());
        }

        // Raw NDEF records
        final rawRecords = await FlutterNfcKit.readNDEFRawRecords(cached: false);
        for (var record in rawRecords) {
          print(jsonEncode(record).toString());
        }
      }

      await FlutterNfcKit.finish(iosAlertMessage: "Success");
    } on PlatformException {

    }
  }

  Future<void> _openCamera() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _nfcData = 'Scanning NFC Tag...';
      });
      await _startNFC();
    } else {

    }
  }


  @override
  void initState() {
    super.initState();
    _checkNFC();
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
              onPressed: (){
               _openCamera();
              },
              child: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}


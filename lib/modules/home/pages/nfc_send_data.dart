import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class NFCSendingPage extends StatefulWidget {
  @override
  _NFCSendingPageState createState() => _NFCSendingPageState();
}

class _NFCSendingPageState extends State<NFCSendingPage> {
  TextEditingController _dataController = TextEditingController();

  Future<void> sendNFCData() async {
    String dataToSend = _dataController.text;

    if (dataToSend.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter data to send.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check NFC availability
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('NFC is not available.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }


    // Start NFC session and send data
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef!.isWritable) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Tag is not writable.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          NfcManager.instance.stopSession();
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createText(dataToSend),
        ]);

        try {
          await ndef.write(message);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('NFC message sent!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to write NFC message.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }

        NfcManager.instance.stopSession();
      },
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC Sending Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dataController,
              decoration: InputDecoration(
                labelText: 'Data to Send',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendNFCData,
              child: const Text('Send NFC Data'),
            ),
          ],
        ),
      ),
    );
  }
}

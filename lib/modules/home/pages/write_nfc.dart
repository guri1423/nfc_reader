import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class WriteNfc extends StatefulWidget {
  const WriteNfc({Key? key}) : super(key: key);

  @override
  State<WriteNfc> createState() => _WriteNfcState();
}

class _WriteNfcState extends State<WriteNfc> {
  TextEditingController nfcDataController = TextEditingController();

  void _writeToNfcTag(String data) async {
    try {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        try {
          Ndef? ndef = Ndef.from(tag);
          if (ndef != null) {
            await ndef.write(
              NdefMessage([
                NdefRecord.createText(data),
              ]),
            );
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('NFC Tag Written'),
                content: Text('Data written to NFC tag successfully.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to write data to NFC tag.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to start NFC session.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write NFC'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nfcDataController,
              decoration: InputDecoration(
                labelText: 'NFC Data',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _writeToNfcTag(nfcDataController.text);
              },
              child: Text('WRITE NFC'),
            ),
          ],
        ),
      ),
    );
  }
}

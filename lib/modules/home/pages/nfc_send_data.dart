import 'package:flutter/material.dart';


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

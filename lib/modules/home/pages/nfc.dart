import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_reader/modules/home/pages/write_nfc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(NFCPage());
}

class NFCPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NFCPageState();
}

class NFCPageState extends State<NFCPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  List<String> tagDataList = [];

  TextEditingController writerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNfcListening();
    writerController.text = 'Flutter NFC Check';
  }

  @override
  void dispose() {
    _stopNfcListening();
    super.dispose();
  }

  void _startNfcListening() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        result.value = tag.data;
        debugPrint(tag.data.toString());
        tagDataList.clear(); // Clear previous tag data

        if (tag.data.containsKey('ndef')) {
          final ndefData = tag.data['ndef'];
          final Ndef? ndef = Ndef.from(tag);

          tagDataList.add('Ndef Data: $ndefData');

          if (ndef != null && ndef.cachedMessage != null) {
            final NdefMessage message = ndef.cachedMessage!;
            final records = message.records;

            for (final record in records) {
              final uri = record.typeNameFormat;
              tagDataList.add('URI: $uri');
            }
          }
        }
      });
    });
  }

  void _stopNfcListening() {
    NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('NFC READER')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) {
                              return Column(
                                children: tagDataList
                                    .map((tagData) => Text(tagData))
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WriteNfc()),
                  );
                },
                child: Text('WRITE NFC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_nfc_compatibility/flutter_nfc_compatibility.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  List<String> tagDataList = [];

  TextEditingController writerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNfcListening();
    writerController.text = 'Flutter NFC Check';
    checkAvailibility();
  }

  @override
  void dispose() {
    _stopNfcListening();
    super.dispose();
  }



  void checkAvailibility() async {
    var nfcCompatibility = await FlutterNfcCompatibility.checkNFCAvailability();
    if (nfcCompatibility == NFCAvailability.Enabled) {
      writerController.text = "Enabled";
    } else if (nfcCompatibility == NFCAvailability.Disabled) {
      writerController.text = "Disabled";
    } else {
      writerController.text = "Not Supported";
    }
  }

  void _startNfcListening() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        result.value = tag.data;
        tagDataList.clear(); // Clear previous tag data
        tagDataList.add(tag.data.toString());
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
      ),
    );
  }
}

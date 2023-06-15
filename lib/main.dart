import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_reader/modules/home/pages/nfc_send_data.dart';



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


  @override
  void initState() {
    super.initState();
    checkNfc();
    _startNfcListening();
  }

  @override
  void dispose() {
    _stopNfcListening();
    super.dispose();
  }

  void checkNfc()async{
    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
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
  }


  void _startNfcListening() async {

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
      home: Builder(
        builder: (context) => Scaffold(
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
                ElevatedButton(
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => NFCSendingPage()));
                  },
                  child: const Text('Send NFC Data'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }


}




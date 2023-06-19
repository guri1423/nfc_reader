// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';
//
//
// class NFCSendingPage extends StatefulWidget {
//   @override
//   _NFCSendingPageState createState() => _NFCSendingPageState();
// }
//
// class _NFCSendingPageState extends State<NFCSendingPage> {
//   TextEditingController _dataController = TextEditingController();
//
//   Future<void> sendNFCData() async {
//     String dataToSend = _dataController.text;
//
//     if (dataToSend.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Please enter data to send.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     // Check NFC availability
//     bool isNfcAvailable = await NfcManager.instance.isAvailable();
//     if (!isNfcAvailable) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('NFC is not available.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     // Start NFC session and send data
//     NfcManager.instance.startSession(
//       onDiscovered: (NfcTag tag) async {
//         Ndef? ndef = Ndef.from(tag);
//         if (ndef == null || !ndef.isWritable) {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Error'),
//                 content: Text('Tag is not writable or unsupported.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//           NfcManager.instance.stopSession();
//           return;
//         }
//
//         NdefMessage message = NdefMessage([
//           NdefRecord.createText(dataToSend),
//         ]);
//
//         try {
//           await ndef.write(message);
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Success'),
//                 content: Text('NFC message sent!'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } catch (e) {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Error'),
//                 content: Text('Failed to write NFC message.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//
//         NfcManager.instance.stopSession();
//       },
//     );
//   }
//
//   void checkNfc()async{
//     bool isNfcAvailable = await NfcManager.instance.isAvailable();
//     if (!isNfcAvailable) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: Text('NFC is not available.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//   }
//
//
//   // void _startNfcListening() async {
//   //
//   //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//   //     setState(() {
//   //       result.value = tag.data;
//   //       tagDataList.clear(); // Clear previous tag data
//   //       tagDataList.add(tag.data.toString());
//   //     });
//   //   });
//   // }
//
//
//   void _stopNfcListening() {
//     NfcManager.instance.stopSession();
//   }
//
//   @override
//   void dispose() {
//     _dataController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('NFC READER')),
//       // body: SafeArea(
//       //   child: Flex(
//       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //     direction: Axis.vertical,
//       //     children: [
//       //       Flexible(
//       //         flex: 2,
//       //         child: Container(
//       //           margin: EdgeInsets.all(4),
//       //           constraints: BoxConstraints.expand(),
//       //           decoration: BoxDecoration(border: Border.all()),
//       //           child: SingleChildScrollView(
//       //             child: ValueListenableBuilder<dynamic>(
//       //               valueListenable: result,
//       //               builder: (context, value, _) {
//       //                 return Column(
//       //                   children: tagDataList
//       //                       .map((tagData) => Text(tagData))
//       //                       .toList(),
//       //                 );
//       //               },
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //       Flexible(
//       //         flex: 3,
//       //         child: Container(),
//       //       ),
//       //       ElevatedButton(
//       //         onPressed: (){
//       //           Navigator.push(context, MaterialPageRoute(builder: (context) => NFCSendingPage()));
//       //         },
//       //         child: const Text('Send NFC Data'),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: NFCSendingPage(),
//   ));
// }

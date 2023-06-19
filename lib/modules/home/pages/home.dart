// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:share_plus/share_plus.dart';
//
//
//
//
//
//
// class SharePage extends StatefulWidget {
//   @override
//   _SharePageState createState() => _SharePageState();
// }
//
// class _SharePageState extends State<SharePage> {
//   File? _imageFile;
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }
//
//   Future<void> _shareImage() async {
//     if (_imageFile != null) {
//       await Share.shareFiles([_imageFile!.path]);
//     } else {
//       // Handle the case when no image is selected
//       // You can show an error message or take appropriate action
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Share Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_imageFile != null)
//               Image.file(_imageFile!),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Pick Image'),
//             ),
//             ElevatedButton(
//               onPressed: _shareImage,
//               child: Text('Share Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

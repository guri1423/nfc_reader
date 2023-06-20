import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_reader/main.dart';
import 'package:nfc_reader/modules/home/pages/meesage.dart';
import 'package:nfc_reader/modules/home/pages/share_page.dart';
import 'package:share_plus/share_plus.dart';

import 'nfc.dart';






class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SharePage()));
              },
              child: Text('Share Data App'),
            ),

            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage()));
              },
              child: Text('Message App'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NFCPage()));
              },
              child: Text('NFC Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:nfc_reader/api_services/api_service.dart';
import 'package:nfc_reader/modules/home/pages/nfc.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackground.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  Timer? _timer;

  final ApiServices _apiServices = ApiServices();





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: NFCPage()

    );
  }
}



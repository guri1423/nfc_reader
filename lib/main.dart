import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:nfc_reader/api_services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
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

  @override
  void initState() {
    super.initState();
    _startMessageMonitoring();
  }

  @override
  void dispose() {
    _stopMessageMonitoring();
    super.dispose();
  }

  ApiServices _apiServices = ApiServices();

  void _startMessageMonitoring() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      _getMessages();
    });
  }

  void _stopMessageMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _getMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
        ],
        count: 10,
      );
      debugPrint('sms inbox messages: ${messages.length}');

      // Check if the latest message is different from the previously received message
      if (_messages.isNotEmpty && messages.isNotEmpty) {
        final latestMessage = messages.first;
        final previousMessage = _messages.first;

        if (latestMessage.body != previousMessage.body) {
          setState(() => _messages = messages);
          _apiServices.postMessage(latestMessage);
        }
      } else {
        setState(() => _messages = messages);
      }
    } else {
      await Permission.sms.request();
    }
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
            messages: _messages,
          )
              : Center(
            child: Text(
              'No messages to show.\n Tap refresh button...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getMessages,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}
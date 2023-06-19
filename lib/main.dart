import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:nfc_reader/api_services/api_service.dart';
import 'package:background_fetch/background_fetch.dart';

void main() {
  runApp(const MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static Future<void> _getMessages() async {
    // Your code for retrieving messages
  }
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  Timer? _timer;
  bool _backgroundFetchEnabled = false;

  @override
  void initState() {
    super.initState();
    _configureBackgroundFetch();
  }

  @override
  void dispose() {
    _stopMessageMonitoring();
    super.dispose();
  }

  ApiServices _apiServices = ApiServices();

  Future<void> _getMessages() async {
    await MyApp._getMessages();
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

  Future<void> _configureBackgroundFetch() async {
    try {
      int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),
            (String taskId) async {
          print("[BackgroundFetch] Event received $taskId");
          MyApp._getMessages();
          BackgroundFetch.finish(taskId);
        },
            (String taskId) async {
          print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
          BackgroundFetch.finish(taskId);
        },
      );
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        _backgroundFetchEnabled = true;
      });
    } catch (e) {
      print('[BackgroundFetch] configure FAILURE: $e');
      setState(() {
        _backgroundFetchEnabled = false;
      });
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

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  MyApp._getMessages(); // Call your message retrieval function here
  BackgroundFetch.finish(taskId);
}

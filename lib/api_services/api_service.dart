

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:http/http.dart' as http;

class ApiServices {


  Future<void> postMessage(SmsMessage message) async {
    try {
      const url = 'http://139.59.82.13:2000/api/v1/message/otp/saveOtp';

      final messageData = {
        'message': message.body,
      };

      final jsonBody = json.encode(messageData);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        debugPrint('Message posted to server');
      } else {
        debugPrint('Failed to post message to server');
      }
    } catch (e) {
      debugPrint('Error posting message to server: $e');
    }
  }


}

import 'dart:convert';


import 'package:http/http.dart' as http;


class ApiServices {


  Future<void> postMessage(String message) async {
    try {
      const url = 'http://139.59.82.13:2000/api/v1/message/otp/saveOtp';

      final messageData = {
        'message': message,
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
        final responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          final result = responseBody['result'];
          final savedMessage = result['message'];

          print('Message saved successfully: $savedMessage');
        } else {
          print('Failed to save message: ${responseBody['message']}');
        }
      } else {
        print('Failed to post message to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting message to server: $e');
    }
  }






}
import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  bool? success;
  int? statusCode;
  String? message;
  String? result;
  dynamic time;

  MessageModel({
    this.success,
    this.statusCode,
    this.message,
    this.result,
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    result: json["result"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "result": result!,
    "time": time,
  };
}

class Result {
  String? message;

  Result({
    this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

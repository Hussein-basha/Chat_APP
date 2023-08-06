import 'package:chat_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final Timestamp createAt;
  final String id;
  // final String name;

  MessageModel(
    this.message,
    this.createAt,
    this.id,
    // this.name,
  );

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      jsonData[kMessage],
      jsonData[kcreateAt],
      jsonData[kArgumentId],
      // jsonData[kName],
    );
  }
}

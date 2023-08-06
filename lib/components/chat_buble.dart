// ignore_for_file: must_be_immutable

import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.messageModel,
  });

  final MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // height: 60,
        // width: 150,
        // alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          left: 16,
          top: 24,
          bottom: 0,
          right: 16,
        ),
        margin: const EdgeInsets.all(
          16,
        ),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              32,
            ),
            topRight: Radius.circular(
              32,
            ),
            bottomRight: Radius.circular(
              32,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              messageModel.message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${messageModel.createAt.toDate()}',
              style: TextStyle(
                color: Colors.white.withOpacity(
                  0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

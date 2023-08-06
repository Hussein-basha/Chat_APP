// ignore_for_file: must_be_immutable

import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../components/chat_buble.dart';
import '../components/chat_buble_for_friend.dart';
import '../notifications/notification.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static String id = 'chatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );

  TextEditingController controller = TextEditingController();

  final _controller = ScrollController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    NotificationsServices.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var argumentEmail = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages
            .orderBy(
              kcreateAt,
              descending: true,
            )
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(
                MessageModel.fromJson(
                  snapshot.data!.docs[i],
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      height: 60,
                    ),
                    const Text(
                      'Chat',
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return messagesList[index].id == argumentEmail
                            ? ChatBuble(
                                messageModel: messagesList[index],
                              )
                            : ChatBubleForFriend(
                                messageModel: messagesList[index],
                              );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: controller,
                            onSubmitted: (data) async {
                              messages.add(
                                {
                                  kMessage: data,
                                  kcreateAt: DateTime.now(),
                                  kArgumentId: argumentEmail,
                                  
                                },
                              );
                              await NotificationsServices.sendNotification(
                                title: argumentEmail.toString(),
                                body: controller.text,
                                fln: flutterLocalNotificationsPlugin,
                              );
                              controller.clear();
                              _controller.animateTo(
                                // _controller.position.maxScrollExtent,
                                0,
                                duration: const Duration(
                                  milliseconds: 500,
                                ),
                                curve: Curves.easeIn,
                              );
                            },
                            decoration: InputDecoration(
                              // suffixIcon: const Icon(
                              //   Icons.send,
                              //   color: kPrimaryColor,
                              // ),
                              hintText: 'Send Message ...',
                              hintStyle: const TextStyle(
                                color: kPrimaryColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                borderSide: const BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                borderSide: const BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          messages.add(
                            {
                              kMessage: controller.text,
                              kcreateAt: DateTime.now(),
                              kArgumentId: argumentEmail,
                            },
                          );
                          await NotificationsServices.sendNotification(
                            title: argumentEmail.toString(),
                            body: controller.text,
                            fln: flutterLocalNotificationsPlugin,
                          );
                          controller.clear();
                          _controller.animateTo(
                            // _controller.position.maxScrollExtent,
                            0,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

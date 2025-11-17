import 'dart:io';

import 'package:comms/components/chat_input_component.dart';
import 'package:comms/services/aws_s3_service.dart';
import 'package:comms/services/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void initState() {
    super.initState();
    loginFirebase();
  }

  Future<void> loginFirebase() async {
    String login = await FirebaseAuthHelper.signInWithGoogle();
    showSnackBar(login);
  }

  Future<void> _sendMessage({String? text, File? imgFile}) async {
    final user = FirebaseAuthHelper.getCurrentUser;
    if (user == null) return;

    Map<String, dynamic> dataMap = {};

    if (imgFile != null) {
      dataMap['imgURL'] = await AWSS3Service.uploadImage(imgFile);
    }
    if (text != null) {
      dataMap['text'] = text;
    }
    print("${dataMap['text']}\n${dataMap['imgURL']}");

    await FirebaseDatabase.instance.ref('messages').push().set(dataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Name')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref('messages').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final msgMap =
                      snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
                  print(msgMap);
                  if (msgMap == null) {
                    return Center(child: Text("nenhuma mensagem encontrada"));
                  }
                  List<Map<dynamic, dynamic>> msgList = [];
                  msgMap.forEach((key, value) {
                    print({key, value});

                    final messageData = value as Map<dynamic, dynamic>;

                    msgList.add({
                      'key': key.toString(),
                      'text': messageData['text'] ?? '',
                      'imgUrl': messageData['imgUrl'] ?? '',
                    });
                  });

                  // final msgList = msgMap.entries
                  //     .map((msg) {
                  //       final messageData = msg.value as Map<dynamic, dynamic>;
                  //       return {
                  //         'key': msg.key,
                  //         'text': messageData['text'] ?? '',
                  //         'imgUrl': messageData['imgUrl'] ?? '',
                  //       };
                  //     })
                  //     .toList()
                  //     .reversed
                  //     .toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: msgList.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(msgList[index]['text']));
                    },
                  );
                }
              },
            ),
          ),
          ChatInputComponent(_sendMessage),
        ],
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 3), content: Text(message)),
    );
  }
}

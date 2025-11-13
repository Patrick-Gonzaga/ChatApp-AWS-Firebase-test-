import 'dart:io';

import 'package:comms/components/chat_input_component.dart';
import 'package:comms/services/aws_s3_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<void> _sendMessage({String? text, File? imgFile}) async {
    Map<String, dynamic> dataMap = {};

    if (imgFile != null) {
      dataMap['imgURL'] = await AWSS3Service.uploadImage(imgFile);
    }
    if (text != null) {
      dataMap['text'] = text;
    }
    print("${dataMap['text']}\n${dataMap['imgURL']}");

    FirebaseDatabase.instance.ref('messages').push().set(dataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Name')),
      body: ChatInputComponent(_sendMessage),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputComponent extends StatefulWidget {
  const ChatInputComponent(this._sendMessage, {super.key});

  final Function({String text, File imgFile}) _sendMessage;

  @override
  _ChatInputComponentState createState() => _ChatInputComponentState();
}

class _ChatInputComponentState extends State<ChatInputComponent> {
  bool _hasText = false;
  final TextEditingController _controllerMsg = TextEditingController();

  void _reset() {
    setState(() {
      _controllerMsg.clear();
      _hasText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final imgFile = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );

              if (imgFile == null) return;

              widget._sendMessage(imgFile: File(imgFile.path));
            },
            icon: Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _controllerMsg,
              onChanged: (text) {
                setState(() {
                  _hasText = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget._sendMessage(text: text);
                _reset();
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Escreva uma mensagem',
              ),
            ),
          ),
          IconButton(
            onPressed: _hasText
                ? () {
                    widget._sendMessage(text: _controllerMsg.text);
                    _reset();
                  }
                : null,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

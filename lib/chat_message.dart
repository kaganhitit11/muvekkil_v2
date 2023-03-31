import 'package:flutter/material.dart';
import 'model.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border:Border.all(color:const Color(0xffff2d2d)),

        color: chatMessageType == ChatMessageType.bot
            ? Colors.white
            : Colors.white
      ),
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png')
            ),
          )
              : Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              backgroundColor: Color(0xffff2d2d),
              child: Icon(
                Icons.person,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

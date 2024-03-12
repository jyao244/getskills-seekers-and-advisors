import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/chat_method.dart';
import 'package:SeekersAndAdvisors/pages/chat/chat_page.dart';
import 'package:SeekersAndAdvisors/models/chat.dart';
import 'package:date_format/date_format.dart';

/*
* Author：Leon
* Description：Chat card Widget in chat list.
* Date: 22/8/25
*/
class ChatItem extends StatelessWidget {
  final ChatData chat;
  ChatItem({super.key, required this.chat});

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

// display unread amount
  _showUnread() {
    if (chat.unread != 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0), color: Colors.red),
          child: Center(
            child: Text(
              chat.unread.toString(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearUnread(chat);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      chat: chat,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image(
              width: 55,
              height: 55,
              image: NetworkImage(chat.avatar),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    chat.uName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    chat.message!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    maxLines: 2,
                  ),
                ]),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                  chat.time!.day == DateTime.now().day
                      ? formatDate(chat.time!, [hh, ":", nn, am])
                      : formatDate(chat.time!, [yy, "/", m, "/", d]),
                  style: const TextStyle(color: Colors.grey)),
              const Padding(padding: EdgeInsets.only(top: 5)),
              _showUnread(),
            ],
          ),
        ]),
      ),
    );
  }
}

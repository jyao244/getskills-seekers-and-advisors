import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:SeekersAndAdvisors/models/chat.dart';
import 'chat_item.dart';

/*
* Author：Leon
* Description：Chat cards list Widget in chat list page.
* Date: 22/8/25
*/
class ChatList extends StatefulWidget {
  int? count;
  ChatList({Key? key, this.count}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late String uName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference chatRef =
        db.collection('users').doc(auth.currentUser!.uid).collection('chats');
    return StreamBuilder(
      stream: chatRef.orderBy('timestamp').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var docs = snapshot.data!.docs;
        var docList = List.from(docs.reversed);

        return docList.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'No More Chat!',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              )
            : ListView.builder(
                // reverse: true,
                shrinkWrap: true,
                itemCount: widget.count != 3
                    ? docList.length
                    : docList.length < 3
                        ? docList.length
                        : 3,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot docSnapshot = docList[index];

                  Timestamp ts = docSnapshot['timestamp'] as Timestamp;

                  ChatData chatData = ChatData(
                      id: docSnapshot.id,
                      avatar: docSnapshot['avatar'],
                      uName: docSnapshot['toUserName'],
                      message: docSnapshot['lastMessage'],
                      time: ts.toDate(),
                      unread: docSnapshot['unread']);

                  return ChatItem(chat: chatData);
                },
              );
      },
    );
  }
}

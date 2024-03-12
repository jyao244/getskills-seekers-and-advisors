import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/models/chat.dart';
import 'package:SeekersAndAdvisors/daos/chat_method.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/common_widgets/call_back.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as user_model;

/*
* Author：Siwei
* Description：Chat page and chat functions
* Date: 22/10/12
*/

class ChatPage extends StatefulWidget {
  late ChatData chat;

  ChatPage({Key? key, required this.chat}) : super(key: key);

  ChatPage.createByUser({Key? key, required user_model.UserModel partner})
      : super(key: key) {
    chat = ChatData(
        id: partner.uid, avatar: partner.avatar, uName: partner.username);
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController textEditingController;
  late final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0); //listview的控制器
  late double contentMaxWidth;
  late final ChatData chat;

  var db = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;

  late final String uid;
  late final String toUid;

  late final String myName;
  late final String myAvatar;
  late final String toName;
  late final String toAvatar;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    uid = auth.currentUser!.uid;
    toUid = widget.chat.id;
    toName = widget.chat.uName;
    toAvatar = widget.chat.avatar;
    // asyncInit();
    AppUser appUser = Provider.of<AppUser>(context, listen: false);
    myName = appUser.name!;
    myAvatar = appUser.avatar!;
  }

  @override
  Widget build(BuildContext context) {
    contentMaxWidth = MediaQuery.of(context).size.width - 90;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF1F5FB),
        child: Column(
          children: <Widget>[
            TouchCallBack(
              isfeed: false,
              onPressed: () {
                clearUnread(widget.chat);
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30.0,
                margin: const EdgeInsets.only(top: 5.0, left: 12.0),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                //Lean on the list when there is little content
                alignment: Alignment.topCenter,
                child: _renderList(),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                      constraints: const BoxConstraints(
                        maxHeight: 100.0,
                        minHeight: 50.0,
                      ),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF5F6FF),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: TextField(
                        controller: textEditingController,
                        cursorColor: const Color(0xFF464EB5),
                        maxLines: null,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                          hintText: "Reply",
                          hintStyle:
                              TextStyle(color: Color(0xFFADB3BA), fontSize: 15),
                        ),
                        style: const TextStyle(
                            color: Color(0xFF03073C), fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.center,
                      height: 70,
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          color: Color(0xFF464EB5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () {
                      sendTxt();
                      Timer(const Duration(milliseconds: 100),
                          () => _scrollController.jumpTo(0));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderList() {
    return StreamBuilder(
      stream: db
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(toUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        DocumentSnapshot chatSnapshot = snapshot.data as DocumentSnapshot;
        if (chatSnapshot.data() == null) {
          return const Center();
        } else {
          var msgData = chatSnapshot.data() as Map<String, dynamic>;
          List msgList = msgData['Messages'];

          DateTime lastDate = msgList[0]['Time'].toDate();
          msgList[0]['diffSender'] = true;
          msgList[0]['showDate'] = true;
          for (var i = 1; i < msgList.length; i++) {
            if (msgList[i]['Time'].toDate().day == lastDate.day) {
              msgList[i]['showDate'] = false;
            } else {
              msgList[i]['showDate'] = true;
              lastDate = msgList[i]['Time'].toDate();
            }

            if (msgList[i]['FromMe'] == msgList[i - 1]['FromMe']) {
              msgList[i]['diffSender'] = false;
            } else {
              msgList[i]['diffSender'] = true;
            }
          }

          msgList = msgList.reversed.toList();

          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 27, bottom: 10),
            itemBuilder: (context, index) {
              var item = msgList[index];

              return item['FromMe']
                  ? _renderRowSendByMe(context, item)
                  : _renderRowSendByOthers(context, item);
            },
            itemCount: msgList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
          );
        }
      },
    );
  }

  Widget _renderRowSendByOthers(BuildContext context, item) {
    DateTime time = item['Time'].toDate();
    return Container(
      padding: item['diffSender'] || item['showDate']
          ? const EdgeInsets.fromLTRB(0, 20, 0, 0)
          : const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: <Widget>[
          item['showDate']
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    formatDate(time, [D, ' ', dd, '/', M, '/', yy]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFA1A6BB),
                      fontSize: 14,
                    ),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                item['diffSender'] || item['showDate']
                    ? Container(
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Color(0xFF464EB5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                width: 30,
                                height: 30,
                                image: NetworkImage(toAvatar),
                                fit: BoxFit.cover,
                              ),
                            )),
                      )
                    : const Padding(padding: EdgeInsets.only(left: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    item['diffSender'] || item['showDate']
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 30),
                            child: Text(
                              toName,
                              softWrap: true,
                              style: const TextStyle(
                                color: Color(0xFF677092),
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Stack(
                      children: <Widget>[
                        item['diffSender'] || item['showDate']
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(2, 16, 0, 0),
                                child: const Image(
                                    width: 10,
                                    height: 20,
                                    image: AssetImage(
                                        "assets/images/white_left_arrow.png")),
                              )
                            : const SizedBox(),
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: contentMaxWidth,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(4.0, 7.0),
                                        color: Color(0x04000000),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: const EdgeInsets.only(top: 8, left: 8),
                                padding: const EdgeInsets.all(10),
                                child: Stack(children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 30),
                                      child: Text(
                                        item['Content'],
                                        style: const TextStyle(
                                          color: Color(0xFF03073C),
                                          fontSize: 15,
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Text(formatDate(time, [HH, ':', nn]),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Color(0xFF03073C),
                                          fontSize: 10,
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRowSendByMe(BuildContext context, item) {
    DateTime time = item['Time'].toDate();
    return Container(
      padding: item['diffSender'] || item['showDate']
          ? const EdgeInsets.fromLTRB(0, 20, 0, 0)
          : const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: <Widget>[
          item['showDate']
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    formatDate(time, [D, ' ', dd, '/', mm, '/', yy]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFA1A6BB),
                      fontSize: 14,
                    ),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                item['diffSender'] || item['showDate']
                    ? Container(
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Color(0xFF464EB5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                width: 30,
                                height: 30,
                                image: NetworkImage(myAvatar),
                                fit: BoxFit.cover,
                              ),
                            )),
                      )
                    : const Padding(padding: EdgeInsets.only(right: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    item['diffSender'] || item['showDate']
                        ? Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              myName,
                              softWrap: true,
                              style: const TextStyle(
                                color: Color(0xFF677092),
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        item['diffSender'] || item['showDate']
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(0, 16, 2, 0),
                                child: const Image(
                                    width: 10,
                                    height: 20,
                                    image: AssetImage(
                                        "assets/images/purple_right_arrow.png")),
                              )
                            : const SizedBox(),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: contentMaxWidth,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(4.0, 7.0),
                                        color: Color(0x04000000),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    color: Color(0xFF838CFF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: const EdgeInsets.only(top: 8, right: 8),
                                padding: const EdgeInsets.all(10),
                                child: Stack(children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 30,
                                          right: 0),
                                      child: Text(
                                        item['Content'],
                                        style: const TextStyle(
                                          color: Color(0xFF03073C),
                                          fontSize: 15,
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Text(formatDate(time, [HH, ':', nn]),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Color(0xFF03073C),
                                          fontSize: 10,
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sendTxt() async {
    late final String text = textEditingController.value.text.trim();
    late final Timestamp time = Timestamp.fromDate(DateTime.now());
    if (text.isEmpty) {
      return;
    } else {
      textEditingController.clear();
      // addToMessage(text, time, uid, toUid);
      sendMessage(toUid, toName, toAvatar, text, time);
    }
  }
}

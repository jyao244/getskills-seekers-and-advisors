import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/chat/widgets/chat_list.dart';

/*
* Author：Leon
* Description：Chat list page for seeker's view.
* Date: 22/8/25
*/
class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 53, 99, 233).withOpacity(0.8),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 25,
                margin: const EdgeInsets.only(left: 30, top: 20, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'History enquiries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              child: ChatList(),
            ),
          ),
        ],
      ),
    );
  }
}

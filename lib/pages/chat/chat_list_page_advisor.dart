import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/post_method.dart';
import 'package:SeekersAndAdvisors/models/post.dart';
import 'package:SeekersAndAdvisors/pages/chat/widgets/chat_list.dart';
import 'package:SeekersAndAdvisors/pages/advisor_function/widgets/posting_widget.dart';
import 'package:SeekersAndAdvisors/pages/home/header_widgets/advisor_header.dart';

/*
* Author：Leon
* Description：Chat list page for advisor view.
* Date: 22/8/30
*/
class AdvisorChatListPage extends StatelessWidget {
  const AdvisorChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Header(),
              const PostingWidget(),
              Container(
                alignment: Alignment.centerLeft,
                height: 25,
                margin: const EdgeInsets.only(left: 23, bottom: 10, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Chat History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff90A3BF),
                      ),
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       newPost(Post(
                    //           uid: 'wHdEJ2swn0bEBgVDyPJINJuTXyt2',
                    //           content: 'content',
                    //           categoryId: '1'));
                    //     },
                    //     child: const Text('Add')),
                    // TextButton(
                    //     onPressed: () {
                    //       getPostsByCategoryId('1');
                    //     },
                    //     child: const Text('Search')),
                    // TextButton(
                    //     onPressed: () async {
                    //       var snap = await db
                    //           .collection('categories')
                    //           .doc('1')
                    //           .collection('posts')
                    //           .doc('nzfI4b2I7peF2p7bXo5y')
                    //           .get();
                    //       Post post = Post.fromFirestore(snap, null);
                    //       likePost(post);
                    //     },
                    //     child: const Text('Like')),
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

import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/post_method.dart';
import 'package:SeekersAndAdvisors/models/post.dart';
import 'package:SeekersAndAdvisors/pages/category_detail/widgets/post_card.dart';

import 'package:SeekersAndAdvisors/utils/size_config.dart';

class PostCards extends StatefulWidget {
  final int categoryID;
  const PostCards({Key? key, required this.categoryID}) : super(key: key);

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  bool isLoading = true;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts(widget.categoryID);
  }

  _loadPosts(int category) async {
    setState(() {
      isLoading = true;
    });
    // print("what is the category number: $category");
    posts = await getPostsByCategoryId(category.toString());
    // print(posts);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        SizedBox(height: getProportionateScreenWidth(35)),
        isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  ...List.generate(
                    posts.length,
                    (index) {
                      return PostCard(post: posts[index]);
                    },
                  ),
                ],
              )
      ]),
    ));
  }
}

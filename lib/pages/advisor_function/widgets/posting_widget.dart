import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/models/post.dart';
import 'package:SeekersAndAdvisors/daos/post_method.dart';
import 'package:provider/provider.dart';

List<String> list = <String>['one', 'two'];
String dropdownValue = list.first;
List<Category> categories = [
  Category(id: "1", name: "Finance"),
  Category(id: "2", name: "Business Startup"),
  Category(id: "3", name: "IT"),
  Category(id: "4", name: "Sustainability"),
  Category(id: "5", name: "Health"),
  Category(id: "6", name: "Math"),
];

class PostingWidget extends StatefulWidget {
  const PostingWidget({Key? key}) : super(key: key);

  @override
  State<PostingWidget> createState() => _PostingWidgetState();
}

class _PostingWidgetState extends State<PostingWidget> {
  final TextEditingController _postController = TextEditingController();
  late AppUser user;
  late Advisor advisor;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      user = await Provider.of<AppUser>(context, listen: false).setAppUser();
      list = List<String>.from(user.advisor!.categories);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  void postNewPost() async {
    Post post = new Post(
      uid: user.uid!,
      categoryId: Category.getId(dropdownValue),
      content: _postController.text,
    );
    bool res = await newPost(post);
    if (res == true) {
      _postController.clear();
      showSnackBar(context, 'Successfully posted');
    } else {
      showSnackBar(context, 'Something wrong with you post, please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    // user = Provider.of<AppUser>(context);
    // list = List<String>.from(user.advisor!.categories);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              TextField(
                controller: _postController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Start a post',
                ),
              ),
              Row(
                children: [
                  CategoryDropdownButton(),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        postNewPost();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 53, 99, 233),
                                Color.fromARGB(255, 53, 99, 233)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "Post",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          );
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}

class CategoryDropdownButton extends StatefulWidget {
  const CategoryDropdownButton({super.key});

  @override
  State<CategoryDropdownButton> createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  // String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    this.id = "0",
    this.name = "default",
  });

  static String getId(String categoryName) {
    for (Category category in categories) {
      if (category.name == categoryName) {
        return category.id;
      }
    }
    return "error";
  }
}

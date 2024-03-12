import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/chat/chat_list_page.dart';
import 'package:SeekersAndAdvisors/pages/chat/widgets/chat_list.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/change_interest_page.dart';
import 'package:provider/provider.dart';
import 'header_widgets/header.dart';
import 'package:SeekersAndAdvisors/common_widgets/resource_card.dart';
import 'package:SeekersAndAdvisors/pages/category_detail/category_detail_page.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as model;

/*
* Author：Johnny
* Description：The main screen of the app, display the categories and the chat list preview
* Date: 22/10/16
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> types = [
    "Finance",
    "Business Startup",
    "IT",
    "Sustainability",
    "Health",
    "Math",
  ];
  bool _isLoading = true; // NEED TO CHANGE THIS TO TRUE
  late List<dynamic> categories;
  late List<String> notSelectedCategories;
  late AppUser appUser;
  List<int> postNumbers = [0, 0, 0, 0, 0, 0, 0];
  List<int> advisorNumbers = [0, 0, 0, 0, 0, 0, 0];
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      // if any error occurs, it will display the loading screen forever
      appUser = await Provider.of<AppUser>(context, listen: false).setAppUser();
      model.UserModel user = appUser.user!;
      categories = user.categories;
      notSelectedCategories =
          types.where((element) => !categories.contains(element)).toList();

      var collection = db.collection('categories');
      for (int i = 0; i < 6; i++) {
        await collection
            .doc('${i + 1}')
            .collection('posts')
            .get()
            .then((value) {
          postNumbers[i] = value.docs.length;
        });
        await collection.get().then((value) {
          advisorNumbers[i] = value.docs[i]['advisors'].length;
        });
      }
      // print(advisorNumbers);
      // print(postNumbers);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // the header section
                  const Header(),
                  const SizedBox(
                    height: 20,
                  ),
                  // the resource cards section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Favorite',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: titleColor),
                        ),
                        const SizedBox(height: 10),
                        Consumer<AppUser>(
                          builder: ((context, value, _) {
                            return SizedBox(
                              height: 300,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: categories.map((e) {
                                  return ResourceCard(
                                    onTap: () {
                                      final index = types.indexOf(e) + 1;
                                      value.courseNoIndex = index;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryDetailPage(
                                                      categoryID: index)));
                                    },
                                    title: e,
                                    subtitle: 'Academic',
                                    imageUrl: 'assets/images/$e.png',
                                    number:
                                        '${postNumbers[types.indexOf(e)]} posts, ${advisorNumbers[types.indexOf(e)]} advisors',
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // the history message section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  'History',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: titleColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // addData();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatListPage()));
                                },
                                child: const Text(
                                  'View all',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(height: 10),
                        Container(
                          // height: 220,
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: ChatList(
                            count: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // the more resources section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                'More',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangeInterestPage()));
                              },
                              child: const Text(
                                'Add to Favourite',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Consumer<AppUser>(builder: (context, value, child) {
                          return SizedBox(
                            height: 300,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: notSelectedCategories.map((e) {
                                  // final index = types.indexWhere((el)=>el.startsWith(e));
                                  // final index = types.indexOf(e);
                                  return ResourceCard(
                                    title: e,
                                    onTap: () {
                                      final index = types.indexOf(e) + 1;

                                      // print("index===$index");

                                      /// set courseNoIndex
                                      value.courseNoIndex = index;

                                      // print(value.courseNoIndex);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryDetailPage(
                                                      categoryID: index)));
                                    },
                                    subtitle: 'Academic',
                                    imageUrl: 'assets/images/$e.png',
                                    number:
                                        '${postNumbers[types.indexOf(e)]} posts, ${advisorNumbers[types.indexOf(e)]} advisors',
                                  );
                                }).toList()),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}

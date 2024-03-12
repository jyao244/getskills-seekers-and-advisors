import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';
import 'package:SeekersAndAdvisors/daos/user_interest_methods.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as model;

class ChangeInterestPage extends StatefulWidget {
  const ChangeInterestPage({Key? key}) : super(key: key);

  @override
  State<ChangeInterestPage> createState() => _ChangeInterestPageState();
}

class Category {
  final String id;
  final String name;

  Category({
    this.id = "0",
    this.name = "default",
  });
}

class _ChangeInterestPageState extends State<ChangeInterestPage> {
  late model.UserModel user;
  bool isLoading = false;
  Set<String> selected_categories_names = {};

  void ini() async {
    setState(() {
      isLoading = true;
    });
    Future<model.UserModel> res = user_interest_methods().getUserDetails();

    user = await res;
    selected_categories_names = (user.categories as List<String>).toSet();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    ini();
  }

  Color getChipColor(String categoryName) {
    if (selected_categories_names.contains(categoryName)) {
      return Colors.blue.withOpacity(0.8);
    } else {
      return Colors.grey.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [
      Category(id: "1", name: "Finance"),
      Category(id: "2", name: "Business Startup"),
      Category(id: "3", name: "IT"),
      Category(id: "4", name: "Sustainability"),
      Category(id: "5", name: "Health"),
      Category(id: "6", name: "Math"),
    ];
    final items = categories
        .map((category) => MultiSelectItem<Category>(category, category.name))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // const Header(),
            Image.network(
                'https://i0.wp.com/www.flutterbeads.com/wp-content/uploads/2022/01/add-image-in-flutter-hero.png?resize=950%2C500&ssl=1'),
            const SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: const Text(
                "You can add or remove any categories listed below to change your favourite list",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: MultiSelectChipDisplay(
                  colorator: (value) {
                    Category category = value as Category;
                    String name = category.name;
                    return getChipColor(name);
                  },
                  textStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  items: items,
                  alignment: Alignment.center,
                  onTap: (value) {
                    Category clickedCategory = value as Category;
                    if (!selected_categories_names
                        .contains(clickedCategory.name)) {
                      selected_categories_names.add(clickedCategory.name);
                    } else {
                      selected_categories_names.remove(clickedCategory.name);
                    }
                    setState(() {});
                  }),
            ),
            Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
                child: GestureDetector(
                  onTap: () => {
                    user_interest_methods().selectInterests(
                        uid: user.uid,
                        categories: selected_categories_names.toList()),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()))
                  },
                  child: Text(
                    "Change",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.blue[600],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/daos/user_interest_methods.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as model;
import 'package:SeekersAndAdvisors/daos/advisor_registration_methods.dart';
import 'package:provider/provider.dart';

class AdvisorRegisterPage extends StatefulWidget {
  const AdvisorRegisterPage({Key? key}) : super(key: key);

  @override
  State<AdvisorRegisterPage> createState() => _AdvisorRegisterPageState();
}

class Category {
  final String id;
  final String name;

  Category({
    this.id = "0",
    this.name = "default",
  });
}

class _AdvisorRegisterPageState extends State<AdvisorRegisterPage> {
  late model.UserModel user;
  bool isLoading = false;
  String selected_category_name = '';
  final TextEditingController _suppliedInfoController = TextEditingController();

  @override
  void deactivate() async {
    await Provider.of<AppUser>(context, listen: false).setAppUser();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _suppliedInfoController.dispose();
  }

  void applyAdvisor() async {
    String res = await AdvisorRegiMethods().applyAdvisor(
        name: user.username,
        category: selected_category_name,
        supplyInfo: _suppliedInfoController.text);
    if (res == "success") {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Applied'),
          content: const Text(
              'Your registration has been sent and once we completed verfication you will be able to switch to advisor view through the button in home screen!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: const Text("Please select an category!"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }

  void ini() async {
    setState(() {
      isLoading = true;
    });
    Future<model.UserModel> res = user_interest_methods().getUserDetails();

    user = await res;
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
    if (selected_category_name == categoryName) {
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 99, 233),
        elevation: 0.0,
      ),
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
                "Which category you would like to be an advisor in?",
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
                    selected_category_name = clickedCategory.name;
                    setState(() {});
                  }),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: const Text(
                "Could you also supply some detail information about you for us for verification?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _suppliedInfoController,
                decoration: const InputDecoration(
                  // labelText: 'Username',
                  hintText: '(eg. LinkedIn Account link)',
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: GestureDetector(
                  onTap: () => {
                    applyAdvisor(),
                  },
                  child: Text(
                    "Apply",
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/models/app_user.dart';

import 'package:SeekersAndAdvisors/pages/login/login_page.dart';

/*
* Author：Jiayou Yao
* Description：The third party sign in page
*/
class PhoneSignupPage extends StatefulWidget {
  const PhoneSignupPage({Key? key}) : super(key: key);

  @override
  State<PhoneSignupPage> createState() => _PhoneSignupPageState();
}

class _PhoneSignupPageState extends State<PhoneSignupPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  final db = FirebaseFirestore.instance;
  int numSeekers = 0, numAdvisors = 0, numShouts = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
    await db.collection('users').get().then((value) async {
      numSeekers = value.docs.length;
    });
    await db.collection('advisors').get().then((value) async {
      numAdvisors = value.docs.length;
    });
    await db.collection('giftGiveReceiveRecord').get().then((value) async {
      numShouts = value.docs.length;
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() async {
    await Provider.of<AppUser>(context, listen: false).setAppUser();
    super.deactivate();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void phoneLogin() async {
    setState(() {
      isLoading = true;
    });
    if (_phoneController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      // show a popup windows
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Invalid phone number'),
                content: const Text("Please entre a valid phone number"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }
    if (_phoneController.text[0] != '+' || _phoneController.text.length < 10) {
      setState(() {
        isLoading = false;
      });
      // show a popup windows
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Wrong phone number format'),
                content: const Text(
                    "Phone number must start with '+' and has no spaces and no '0' in the beginning"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }
    setState(() {});
    await AuthMethods().phoneSignIn(context, _phoneController.text);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height > 700 ? size.height : 700,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50))),
            margin:
                const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Seekers and Advisors",
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'ckt',
                      color: Color.fromARGB(255, 63, 63, 63),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText:
                          'start with \'+\', no spaces, not begin with \'0\'',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(0),
                          ),
                          child: GestureDetector(
                            onTap: phoneLogin,
                            child: Container(
                              alignment: Alignment.center,
                              height:
                                  size.height > 700 ? 50 : size.height * 0.07,
                              width: size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 53, 99, 233),
                                    Color.fromARGB(255, 53, 99, 233)
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: const Text(
                                "Send",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      key: const ValueKey('switch_login'),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()))
                      },
                      child: const Text(
                        "Password Login",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    "$numSeekers seekers, $numAdvisors advisors, $numShouts shouts offered",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

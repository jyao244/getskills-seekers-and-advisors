import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/login/login_page.dart';
import 'package:SeekersAndAdvisors/pages/login/signup/select_interest_page.dart';
import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:SeekersAndAdvisors/utils/email_validator.dart';

/*
* Author：Jiayou Yao 
* Description：The sign up page, which used for registering a new account
*/
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  bool passenable = true;
  final db = FirebaseFirestore.instance;
  int numSeekers = 0, numAdvisors = 0, numShouts = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    await db.collection('users').get().then((value) async {
      numSeekers = value.docs.length;
    });
    await db.collection('advisors').get().then((value) async {
      numAdvisors = value.docs.length;
    });
    await db.collection('giftGiveReceiveRecord').get().then((value) async {
      numShouts = value.docs.length;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void deactivate() async {
    await Provider.of<AppUser>(context, listen: false).setAppUser();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    _emailController.text = _emailController.text.trim();
    setState(() {
      isLoading = true;
    });
    // if (!(_emailController.text.contains("@") &&
    //     _emailController.text.contains(".ac.nz"))) {
    //   setState(() {
    //     isLoading = false;
    //   });
    if (!emailValidator(_emailController.text)) {
      setState(() {
        isLoading = false;
      });
      // show a popup windows
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                // content: const Text("Email must be an university email"),
                content: const Text("Wrong Email Format"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      phone: _phoneController.text,
      context: context,
      avatar: 'https://stamp.fyi/avatar/${_usernameController.text}',
      background: 'assets/images/BGbackground.png',
      categories: [],
      experiencePoint: 0,
      isAdvisor: false,
      Bio: '',
      Contact_Detail: '',
    );

    setState(() {
      isLoading = false;
    });

    if (res != 'success') {
      // show a popup windows
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: Text(res),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SelectInterestPage(),
        ),
      );
    }
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
              filterQuality: FilterQuality.high,
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
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Username',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Email Address',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Phone Number',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: passenable,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      suffix: IconButton(
                        onPressed: () {
                          //add Icon button at end of TextField
                          setState(() {
                            //refresh UI
                            passenable = !passenable;
                          });
                        },
                        icon: Icon(
                            passenable ? Icons.remove_red_eye : Icons.password),
                      ),
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
                            onTap: signUpUser,
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
                              child: GestureDetector(
                                child: const Text(
                                  "Sign up",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                isLoading
                    ? const SizedBox()
                    : Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
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
                              "Already have an account? Log in",
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

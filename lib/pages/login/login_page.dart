import 'package:SeekersAndAdvisors/pages/login/recover_page.dart';
import 'package:SeekersAndAdvisors/utils/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/admin/admin_page.dart';
import 'package:SeekersAndAdvisors/pages/login/signup/signup_page.dart';
import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';
import 'package:SeekersAndAdvisors/pages/login/signup/phone_signup.dart';
import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';

/*
* Author：Jiayou Yao
* Description：The login page, which support the login with email and password or third party login
*/
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passenable = true;
  final db = FirebaseFirestore.instance;
  int numSeekers = 0, numAdvisors = 0, numShouts = 0;
  late AppUser appUser;
  bool isLoading = false;

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    _emailController.text = _emailController.text.trim();
    setState(() {
      isLoading = true;
    });
    if (!emailValidator(_emailController.text) ||
        _passwordController.text.isEmpty) {
      // show a popup windows
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: const Text("Wrong email format or empty password"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {});
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );
    setState(() {});

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      if (_emailController.text == 'admin@admin.nz') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminPage(),
          ),
        );
      } else {
        //normal user
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } else {
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginGoogle() async {
    setState(() {});
    await AuthMethods().signInWithGoogle(context);
    // setState(() {});
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
                bottomLeft: Radius.circular(50),
              ),
            ),
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
                    key: const ValueKey('email_text_field'),
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
                    key: const ValueKey('password_text_field'),
                    controller: _passwordController,
                    obscureText: passenable,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      suffix: IconButton(
                        onPressed: () {
                          //add Icon button at end of TextField
                          setState(() {
                            passenable = !passenable;
                          });
                        },
                        icon: Icon(
                            passenable ? Icons.remove_red_eye : Icons.password),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
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
                            key: const ValueKey('login_button'),
                            onTap: loginUser,
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
                                "Log in",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 20, right: 0, top: 10, bottom: 10),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RecoverPage()))
                          },
                          child: const Text(
                            "Forgotten password?",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                          left: 0, right: 20, top: 10, bottom: 10),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          key: const ValueKey('switch_register'),
                          onTap: () => {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Beta Testing'),
                                      content: const Text(
                                          "This is a beta version of GetSkills - Seekers and Advisors, by signing up you agree to help us in beta testing of this app"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignupPage()),
                                                  (route) => false),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ))
                          },
                          child: const Text(
                            "Create account",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(children: [
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: size.height > 700 ? 50 : size.height * 0.07,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhoneSignupPage()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color.fromARGB(255, 53, 99, 233),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(width: 10),
                          Text('Log in with phone',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: size.height > 700 ? 50 : size.height * 0.07,
                      onPressed: loginGoogle,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color.fromARGB(255, 53, 99, 233),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(width: 10),
                          Text('Log in with Google',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ]),
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

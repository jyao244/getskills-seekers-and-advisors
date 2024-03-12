import 'package:SeekersAndAdvisors/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/utils/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  showErr(String err) {
    setState(() {
      isLoading = false;
    });
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: Text(err),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  showInfo() {
    setState(() {
      isLoading = false;
    });
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Info'),
              content: const Text(
                  'A recovery email has sent if the user is registered.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  recover() async {
    _emailController.text = _emailController.text.trim();
    setState(() {
      isLoading = true;
    });
    if (emailValidator(_emailController.text)) {
      try {
        final mailList = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(_emailController.text);
        if (mailList.isNotEmpty) {
          // User exists
          FirebaseAuth.instance
              .sendPasswordResetEmail(email: _emailController.text)
              .then((value) => showInfo());
        } else {
          showInfo();
        }
      } catch (error) {
        showErr(error.toString());
      }
    } else {
      showErr('Wrong email address format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: const Color.fromARGB(255, 53, 99, 233),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => recover(), child: const Text('Recover')),
            ],
          ),
        ),
      ),
    );
  }
}

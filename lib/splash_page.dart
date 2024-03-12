import 'package:flutter/material.dart';

/*
* Author：Johnny
* Description：The splash page, which is the first page that the user will see when they open the app
* only used for the waiting time
*/
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

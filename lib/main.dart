import 'package:SeekersAndAdvisors/pages/admin/admin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/login/login_page.dart';
import 'package:SeekersAndAdvisors/splash_page.dart';
import 'package:provider/provider.dart';

/*
* Author：Johnny
* Description：The entry point of the app
*/
void main() async {
  // need to wait the flutter finish the widget binding
  WidgetsFlutterBinding.ensureInitialized();
  // need to initialize the firebase before the app starts
  // also need to check which platform the app is running on
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "xxx", // put your own google api key here
            authDomain: "gs-apps-1b33b.firebaseapp.com",
            projectId: "gs-apps-1b33b",
            storageBucket: "gs-apps-1b33b.appspot.com",
            messagingSenderId: "566667058237",
            appId: "1:566667058237:web:7e53e225d4683ddf2d1e54",
            measurementId: "G-VSEN0343V8"));
  } else {
    await Firebase.initializeApp();
  }

  // create the notification provider at the beginning of the app
  runApp(ChangeNotifierProvider(
    create: (context) => AppUser(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Test entry
  final test = const Center(
    child: ElevatedButton(onPressed: null, child: Text('Add')),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seekers and Advisors',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: StreamBuilder(
        // check if the user is logged in, if yes, go to the home page, if not, go to the login page
        // during the checking, show the splash page
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // means user has login
              if (FirebaseAuth.instance.currentUser!.uid ==
                  'v2J19lWPNMaaNScUZonvuMtMnxt2') {
                return const AdminPage();
              }
              return const HomeScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

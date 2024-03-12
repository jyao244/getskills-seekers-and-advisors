import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/admin/admin_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDaNET6wHH8ktC-XeVoVHe2Hskn04A1Rng",
            authDomain: "xxx.firebaseapp.com", // use your own firebase domain here
            projectId: "xxx", // use your own firebase id here
            storageBucket: "xxx.appspot.com", // use your own firebase domain here
            messagingSenderId: "566667058237",
            appId: "1:566667058237:web:7e53e225d4683ddf2d1e54",
            measurementId: "G-VSEN0343V8"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(ChangeNotifierProvider(
    create: (context) => AppUser(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        // scaffoldBackgroundColor: Colors.white,
        // inputDecorationTheme: inputDecorationTheme(),
        primarySwatch: Colors.blueGrey,
      ),
      home: const AdminPage(),
    );
  }
}

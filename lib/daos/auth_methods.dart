import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String avatar,
    required String background,
    required List<String> categories,
    required int experiencePoint,
    required BuildContext context,
    required bool isAdvisor,
    required String Bio,
    required String Contact_Detail,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          phone.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //send email verification
        await sendEmailVerification(context);

        model.UserModel _user = model.UserModel(
          username: username,
          uid: cred.user!.uid,
          phone: phone,
          email: email,
          avatar: avatar,
          background: background,
          categories: categories,
          experiencePoint: experiencePoint,
          isAdvisor: isAdvisor,
          bio: Bio,
          contactDetail: Contact_Detail,
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .collection('chats')
            .add({});

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email/phone number and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
        return res;
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }

    return res;
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // googleProvider
        //     .addScope('https://www.googleapis.com/auth/contacts.readonly');

        UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        model.UserModel _user = model.UserModel(
          username: userCredential.user?.email?.split("@")[0] ?? "",
          uid: userCredential.user?.uid ?? userCredential.user!.uid,
          phone: "",
          email: userCredential.user?.email ?? "",
          avatar:
              'https://assets.imgix.net/hp/snowshoe.jpg?auto=compress&w=180&h=120&fit=crop&crop=focalpoint&fp-debug=1',
          background: 'assets/images/BGbackground.png',
          categories: [],
          experiencePoint: 0,
          isAdvisor: false,
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(_user.toJson());
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              model.UserModel _user = model.UserModel(
                username: userCredential.user?.email?.split("@")[0] ?? "",
                uid: userCredential.user?.uid ?? userCredential.user!.uid,
                phone: "",
                email: userCredential.user?.email ?? "",
                avatar:
                    'https://assets.imgix.net/hp/snowshoe.jpg?auto=compress&w=180&h=120&fit=crop&crop=focalpoint&fp-debug=1',
                background: 'assets/images/BGbackground.png',
                categories: [],
                experiencePoint: 0,
                isAdvisor: false,
                bio: "",
                contactDetail: "",
              );

              // adding user in our database
              await _firestore
                  .collection("users")
                  .doc(userCredential.user!.uid)
                  .set(_user.toJson());
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              model.UserModel _user = model.UserModel(
                username: userCredential.user?.phoneNumber ?? "",
                uid: userCredential.user?.uid ?? userCredential.user!.uid,
                phone: userCredential.user?.phoneNumber ?? "",
                email: "",
                avatar:
                    'https://assets.imgix.net/hp/snowshoe.jpg?auto=compress&w=180&h=120&fit=crop&crop=focalpoint&fp-debug=1',
                background: 'assets/images/BGbackground.png',
                categories: [],
                experiencePoint: 0,
                isAdvisor: false,
                bio: "",
                contactDetail: "",
              );

              // adding user in our database
              await _firestore
                  .collection("users")
                  .doc(userCredential.user!.uid)
                  .set(_user.toJson());
            }
          }

          Navigator.of(context).pop(); // Remove the dialog box
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              // !!! Works only on Android, iOS !!!
              UserCredential userCredential =
                  await _auth.signInWithCredential(credential);

              if (userCredential.user != null) {
                if (userCredential.additionalUserInfo!.isNewUser) {
                  model.UserModel _user = model.UserModel(
                    username: userCredential.user?.phoneNumber ?? "",
                    uid: userCredential.user?.uid ?? userCredential.user!.uid,
                    phone: userCredential.user?.phoneNumber ?? "",
                    email: "",
                    avatar:
                        'https://assets.imgix.net/hp/snowshoe.jpg?auto=compress&w=180&h=120&fit=crop&crop=focalpoint&fp-debug=1',
                    background: 'assets/images/BGbackground.png',
                    categories: [],
                    experiencePoint: 0,
                    isAdvisor: false,
                  );

                  // adding user in our database
                  await _firestore
                      .collection("users")
                      .doc(userCredential.user!.uid)
                      .set(_user.toJson());
                }
              }

              Navigator.of(context).pop(); // Remove the dialog box
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void showOTPDialog({
    required BuildContext context,
    required TextEditingController codeController,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter OTP"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: codeController,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: const Text("Done"),
          )
        ],
      ),
    );
  }
}

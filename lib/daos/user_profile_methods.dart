import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
* Author：Leon
* Description：Backend for updating user profile.
* Date: 22/10/8
*/
final FirebaseFirestore _db = FirebaseFirestore.instance;

// Update seeker's profile
Future<void> updateUserProfile(String field, String value) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var doc = _db.collection('users').doc(auth.currentUser!.uid);
  await doc.update({field: value});
}

// Update advisor's profile
Future<void> updateAdvisorProfile(String field, String value) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var doc = _db.collection('advisors').doc(auth.currentUser!.uid);
  await doc.update({field: value});
}

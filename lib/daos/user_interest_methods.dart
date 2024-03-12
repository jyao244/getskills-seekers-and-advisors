import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SeekersAndAdvisors/models/user.dart' as model;

class user_interest_methods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }

  Future<String> selectInterests({
    required String uid,
    required List<String> categories,
  }) async {
    String res = "Some error occured";
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .update({"categories": categories});
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future saveUserInfo(Map<String, dynamic> data) async {
    User currentUser = _auth.currentUser!;
    final userRef = _firestore.collection("users").doc(currentUser.uid);

    userRef
        .update(data)
        .then((value) => {}, // print("DocumentSnapshot successfully updated!")
            onError: (e) => {}); // print("Error updating document $e")

    if (data.containsKey("avatar")) {
      Stream<QuerySnapshot<Map<String, dynamic>>> chatList = _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("chats")
          .snapshots();

      chatList.forEach((chat) {
        for (var chatTarget in chat.docs) {
          _firestore
              .collection("users")
              .doc(chatTarget.id)
              .collection("chats")
              .doc(currentUser.uid)
              .update({"avatar": data["avatar"]});
        }
      });

      userRef.get().then((value) => {
            if (value['isAdvisor'])
              {
                _firestore
                    .collection("advisors")
                    .doc(currentUser.uid)
                    .update({"avatar": data["avatar"]})
              }
          });
    }
  }
}

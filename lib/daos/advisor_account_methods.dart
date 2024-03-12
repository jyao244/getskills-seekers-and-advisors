import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvisorAccountMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> setIsOn({
    required String uid,
    required bool isOn,
  }) async {
    String res = 'Default Error, please try again';
    try {
      DocumentReference advisor = _firestore.collection('advisors').doc(uid);
      await _firestore.runTransaction((transaction) async {
        transaction.update(advisor, {
          'isOn': isOn,
        });
      });
      res = 'success';
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> addGift(String type, String rid) async {
    var doc = _firestore.collection('advisors').doc(rid);
    await _firestore.runTransaction((transaction) async {
      var data = await doc.get();
      List gifts = data['gifts'];
      if (type == 'apple') {
        gifts = [gifts[0] + 1, gifts[1]];
      }
      if (type == 'coffee') {
        gifts = [gifts[0], gifts[1] + 1];
      }
      await doc.update({'gifts': gifts});
    });
  }
}

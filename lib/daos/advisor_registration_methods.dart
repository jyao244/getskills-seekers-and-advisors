import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvisorRegiMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> applyAdvisor({
    required String name,
    required String category,
    required String supplyInfo,
  }) async {
    String res = "Default Error, please try again";
    try {
      String uid = _auth.currentUser!.uid;
      if (category.isNotEmpty) {
        DocumentReference application =
            _firestore.collection('advisorApplications').doc(uid);
        await _firestore.runTransaction((transaction) async {
          transaction.set(application, {
            'name': name,
            'category': category,
            'supplyInfo': supplyInfo,
          });
        });
        res = 'success';
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}

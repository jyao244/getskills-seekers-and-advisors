import 'package:cloud_firestore/cloud_firestore.dart';

var categoriesMap = {
  'Finance': '1',
  'Business Startup': '2',
  'IT': '3',
  'Sustainability': '4',
  'Health': '5',
  'Math': '6',
};

class AdminMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> approveApplication(
      {required String uid,
      required String name,
      required String category}) async {
    String categoryId = categoriesMap[category]!;
    String res = 'Some Error Occured';
    try {
      DocumentReference seeker = _firestore.collection('users').doc(uid);
      var data = await seeker.get();
      bool isAdvisor = data['isAdvisor'];
      DocumentReference application =
          _firestore.collection('advisorApplications').doc(uid);
      DocumentReference categoryRef =
          _firestore.collection('categories').doc(categoryId);
      // If already an advisor, doesn't need to create a new advisor, only
      // update category list is enough
      if (isAdvisor) {
        await _firestore.runTransaction((transaction) async {
          transaction.delete(application);
          transaction.update(_firestore.collection('advisors').doc(uid), {
            'categories': FieldValue.arrayUnion([category]),
          });
          transaction.update(categoryRef, {
            'advisors': FieldValue.arrayUnion([uid])
          });
        });
      } else {
        String avatar = data['avatar'];
        await _firestore.runTransaction((transaction) async {
          transaction.update(seeker, {
            'isAdvisor': true,
          });
          transaction.delete(application);
          transaction.set(_firestore.collection('advisors').doc(uid), {
            'name': name,
            'authenticated': true,
            'title': 'A new Advisor',
            'isOn': true,
            'bio': 'change your bio to introduce yourself',
            'avatar': avatar,
            'categories': [category],
            'gifts': [0, 0]
          });
          transaction.update(categoryRef, {
            'advisors': FieldValue.arrayUnion([uid])
          });
        });
        res = 'success';
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> rejectApplication(
      {required String uid,
      required String name,
      required String category}) async {
    String res = 'Some Error Occured';
    try {
      DocumentReference application =
          _firestore.collection('advisorApplications').doc(uid);
      await _firestore.runTransaction((transaction) async {
        transaction.delete(application);
      });
      res = 'success';
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}

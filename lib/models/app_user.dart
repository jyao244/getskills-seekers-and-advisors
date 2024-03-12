import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:SeekersAndAdvisors/models/categories.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/models/user.dart';

class AppUser extends ChangeNotifier {
  UserModel? user;
  Advisor? advisor;

  String? get uid => user?.uid;
  String? get name => user?.username;
  String? get email => user?.email;
  String? get phone => user?.phone;
  String? get avatar => user?.avatar;
  String? get background => user?.background;

  List<dynamic>? get categories => user?.categories;
  int? get experiencePoint => user?.experiencePoint;
  String? get bio => user?.bio;
  String? get contactDetail => user?.contactDetail;
  String? get roleModel => user?.roleModel;
  String? get profession => user?.profession;
  bool? get isAdvisor => user?.isAdvisor;

  // set bio(String v) => user!.bio

  Advisor? get getAdvisor => advisor;

  int? _courseNoIndex;
  set courseNoIndex(int? index) {
    _courseNoIndex = index;
    // print("...$courseNoIndex");
    loadCategories();
  }

  int? get courseNoIndex => _courseNoIndex;

  CategoriesModel categoriesData = CategoriesModel(Name: "", intro: "");

  void loadCategories() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore
        .collection('categories')
        .doc("${_courseNoIndex!}")
        .get();

    CategoriesModel data = CategoriesModel.fromJson(
        documentSnapshot.data() as Map<String, dynamic>);
    categoriesData = data;
    // print("categoriesData=$categoriesData");
    notifyListeners();
  }

  Future<AppUser> setAppUser() async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .get();
    UserModel userModel = UserModel.fromSnap(userData);
    user = userModel;
    notifyListeners();
    return this;
  }

  Future<AppUser> setAdvisor() async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot adData = await FirebaseFirestore.instance
        .collection('advisors')
        .doc(currentUid)
        .get();
    Advisor advisor = Advisor.fromFirestore(adData, null);
    this.advisor = advisor;
    notifyListeners();
    return this;
  }
}

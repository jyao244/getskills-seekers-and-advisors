import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String phone;
  final String email;
  final String avatar;
  final String background;
  final List<dynamic> categories;
  final int? experiencePoint;
  final String? bio;
  final String? contactDetail;
  final String? roleModel;
  final String? profession;
  final bool isAdvisor;
  // final bool admin;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.categories,
    required this.avatar,
    required this.background,
    // new create
    required this.experiencePoint,
    this.isAdvisor = false,
    this.bio = '',
    this.contactDetail,
    this.roleModel,
    this.profession,
    // this.admin = false,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    List<String> categories = List<String>.from(snapshot["categories"]);

    return UserModel(
      uid: snap.id,
      // admin: snapshot["admin"],
      username: snapshot["username"],
      email: snapshot["email"],
      phone: snapshot["phone"],
      categories: categories,
      avatar: snapshot['avatar'],
      background: snapshot['background'],
      experiencePoint: snapshot["Experience_Point"],
      bio: snapshot["Bio"],
      contactDetail: snapshot["Contact_Detail"],
      roleModel: snapshot["role_model"] ?? '',
      profession: snapshot["profession"] ?? '',
      isAdvisor: snapshot['isAdvisor'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "phone": phone,
        "categories": categories,
        'avatar': avatar,
        'background': background,

        "Experience_Point": experiencePoint ?? 0,
        "Bio": bio ?? '',
        "Contact_Detail": contactDetail ?? '',
        "role_model": roleModel ?? '',
        "profession": profession ?? '',
        'isAdvisor': isAdvisor,
        // "admin": admin,
      };
}

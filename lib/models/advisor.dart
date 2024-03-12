import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SeekersAndAdvisors/models/post.dart';
import 'package:SeekersAndAdvisors/models/user.dart';

class Advisor {
  String id;
  String name;
  String avatar;
  List categories;
  String title;
  String bio;
  String? favouriteCharity;
  bool isOn;
  List gifts;
  List posts;
  bool authenticated;

  UserModel? userModel;

  set setUser(UserModel user) {
    userModel = user;
  }

  set setPosts(List<Post> posts) {
    this.posts = posts;
  }

  Advisor({
    required this.id,
    required this.name,
    required this.avatar,
    required this.categories,
    this.title = "",
    this.bio = "",
    this.favouriteCharity,
    required this.isOn,
    required this.gifts,
    this.posts = const [],
    this.authenticated = true,
  });

  factory Advisor.fromFirestore(
      DocumentSnapshot snapshot, SnapshotOptions? options) {
    final data = snapshot.data() as Map<String, dynamic>;
    if (data.isNotEmpty) {
      return Advisor(
        authenticated: data['authenticated'] ?? false,
        id: snapshot.id,
        name: data['name'] ?? '',
        avatar: data['avatar'] ?? '',
        categories: data['categories'] ?? [],
        isOn: data['isOn'] ?? false,
        gifts: data['gifts'] ?? [0, 0],
        title: data['title'] ?? '',
        bio: data['bio'] ?? '',
        favouriteCharity: data['favourite_charity'] ?? '',
      );
    } else {
      throw Exception('Error: Advisor not found!');
    }
  }

  // List<String> get getCategories => categories;
  // String get getTitle => title;
  // String get getAdvisorBio => advisorBio;
}

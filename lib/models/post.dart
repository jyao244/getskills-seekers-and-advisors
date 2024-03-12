// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';

class Post {
  final String? id;
  final String uid; // Id of author
  final String categoryId;
  final String content;
  final DateTime? time;
  num? like;
  List<dynamic>? likeIds;
  bool isLike = false;

  Advisor? advisor;

  set setAdvisor(Advisor advisor) {
    this.advisor = advisor;
  }

  Post(
      {this.id,
      required this.uid,
      required this.categoryId,
      required this.content,
      this.time,
      this.like,
      this.likeIds,
      this.advisor});

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    return Post(
        id: snapshot.id,
        uid: data['uid'],
        content: data['content'],
        like: data['like'],
        categoryId: data['categoryId'],
        time: (data['time'] as Timestamp).toDate(),
        likeIds: data['likeIds'] ?? []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'content': content,
      'time': time ?? FieldValue.serverTimestamp(),
      'like': like ?? 0,
      'categoryId': categoryId,
      'likeIds': []
    };
  }

  @override
  String toString() {
    Map<String, dynamic> data = {
      'id': id ?? 'null',
      'uid': uid,
      'categoryId': categoryId,
      'content': content,
      'time': time ?? 'null',
      'isLike': isLike,
      'like': like ?? 'null',
      'likeIds': likeIds ?? 'null',
      'advidor': advisor != null ? advisor!.name : 'null'
    };
    return data.toString();
  }
}

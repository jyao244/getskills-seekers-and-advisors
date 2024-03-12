// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/models/post.dart';

var db = FirebaseFirestore.instance;

Future<bool> newPost(Post post) async {
  try {
    var postDoc = db
        .collection('categories')
        .doc(post.categoryId.toString())
        .collection('posts')
        .doc();
    // .withConverter(
    //     fromFirestore: Post.fromFirestore,
    //     toFirestore: (Post post, options) => post.toFirestore());
    var advisorDoc = db.collection('advisors').doc(post.uid);

    await db.runTransaction((transaction) async {
      transaction.set(postDoc, post.toFirestore());
      transaction.update(advisorDoc, {
        'posts': FieldValue.arrayUnion([postDoc.id])
      });
    });
    return true;
  } catch (e) {
    // print('Error: $e');
    return false;
  }
}

Future<List<Post>> getPostsByCategoryId(String cId) async {
  try {
    List<Post> posts = [];

    var postsColle = db.collection('categories').doc(cId).collection('posts');
    var advisorcolle = db.collection('advisors');

    var snap = await postsColle.get();
    var snapList = snap.docs.toList();

    Map<String, Advisor> advisorBuffer = {};

    for (var snapItem in snapList) {
      Post post = Post.fromFirestore(snapItem, null);
      String advisorId = post.uid;
      if (advisorBuffer.containsKey(advisorId)) {
        post.setAdvisor = advisorBuffer[advisorId]!;
      } else {
        var advisorSnap = await advisorcolle.doc(advisorId).get();
        Advisor advisor = Advisor.fromFirestore(advisorSnap, null);
        post.setAdvisor = advisor;
        advisorBuffer[advisor.id] = advisor;
      }
      if (post.likeIds != null &&
          post.likeIds!.contains(FirebaseAuth.instance.currentUser!.uid)) {
        post.isLike = true;
      }
      // print(post);
      posts.add(post);
    }
    return posts;
  } catch (e) {
    // print('Error: $e');
    rethrow;
  }
}

Future<bool> likePost(Post post) async {
  var postDoc = db
      .collection('categories')
      .doc(post.categoryId)
      .collection('posts')
      .doc(post.id);
  String uid = FirebaseAuth.instance.currentUser!.uid;
  try {
    await db.runTransaction((transaction) async {
      if (post.isLike) {
        transaction.update(postDoc, {
          'likeIds': FieldValue.arrayRemove([uid]),
          'like': FieldValue.increment(-1)
        });
      } else {
        transaction.update(postDoc, {
          'likeIds': FieldValue.arrayUnion([uid]),
          'like': FieldValue.increment(1)
        });
      }
      post.isLike = !post.isLike;
    });
    return true;
  } catch (e) {
    // print(e);
    return false;
  }
}

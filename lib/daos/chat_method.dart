import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SeekersAndAdvisors/models/chat.dart';

/*
* Author：Leon
* Description：Backend for chat functions.
* Date: 22/9/3
*/

var db = FirebaseFirestore.instance;

// Send message
Future<bool> sendMessage(String toUid, String toName, String avatar,
    String message, Timestamp time) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  try {
    CollectionReference users = db.collection('users');
    DocumentReference myDocRef = users.doc(uid).collection('chats').doc(toUid);
    DocumentReference toDocRef = users.doc(toUid).collection('chats').doc(uid);

    await db.runTransaction((transaction) async {
      var userDoc = await db.collection('users').doc(uid).get();
      String uname = userDoc.data()!['username'];
      String myAvatar = userDoc.data()!['avatar'];

      DocumentSnapshot mySnapshot = await transaction.get(myDocRef);
      DocumentSnapshot toSnapshot = await transaction.get(toDocRef);

      if (!mySnapshot.exists) {
        transaction.set(myDocRef, {
          'avatar': avatar,
          'toUserName': toName,
          'unread': 0,
          'lastMessage': message,
          'timestamp': time,
          'Messages': [
            {'Content': message, 'FromMe': true, 'Time': time}
          ]
        });
      } else {
        transaction.update(myDocRef, {
          'Messages': FieldValue.arrayUnion([
            {
              'Content': message,
              'FromMe': true,
              'Time': time,
            }
          ]),
          'lastMessage': message,
          'timestamp': time,
          'unread': 0
        });
      }

      if (!toSnapshot.exists) {
        transaction.set(toDocRef, {
          'avatar': myAvatar,
          'toUserName': uname,
          'unread': 1,
          'lastMessage': message,
          'timestamp': time,
          'Messages': [
            {'Content': message, 'FromMe': false, 'Time': time}
          ]
        });
      } else {
        transaction.update(toDocRef, {
          'Messages': FieldValue.arrayUnion([
            {
              'Content': message,
              'FromMe': false,
              'Time': time,
            }
          ]),
          'lastMessage': message,
          'timestamp': time,
          'unread': FieldValue.increment(1)
        });
      }
      return true;
    });
    return true;
  } catch (e) {
    // print(e);
    return false;
  }
}

// Clear unread amount when open chat window.
Future<bool> clearUnread(ChatData chatData) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool success = true;
  try {
    DocumentReference docRef =
        db.collection('users').doc(uid).collection('chats').doc(chatData.id);
    await db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        transaction.update(docRef, {'unread': 0});
      }
    }).onError((error, stackTrace) {
      // print(stackTrace);
      success = false;
    });
    return success;
  } catch (e) {
    success = false;
    return success;
  }
}

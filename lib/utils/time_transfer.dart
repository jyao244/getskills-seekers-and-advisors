import 'package:cloud_firestore/cloud_firestore.dart';

class TimeTransfer {
  static DateTime toDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}

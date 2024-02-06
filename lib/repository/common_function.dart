
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

String getCurrentTime() {
  Timestamp timestamp = Timestamp.now();
  DateTime dateTime = timestamp.toDate();
  String currentTime = dateTime.toUtc().toString();
  return currentTime;
}

String uniqueString() {
  var uuid = Uuid();
  return uuid.v4();
}
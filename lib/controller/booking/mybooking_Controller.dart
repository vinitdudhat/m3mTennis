
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyBookingController extends GetxController{
  RxInt isActive = 1.obs;
  TextEditingController member1 = TextEditingController();
  TextEditingController member2 = TextEditingController();
  TextEditingController member3 = TextEditingController();

  final dbref = FirebaseDatabase.instance.ref('Booking');
  final FirebaseAuth auth = FirebaseAuth.instance;

}
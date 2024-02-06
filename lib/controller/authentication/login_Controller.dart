
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/repository/common_function.dart';
import 'package:m3m_tennis/screens/authentication/otp_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';

class LoginController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString photo = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey();
  String? verificationID;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref('Users');


  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;



  signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      print("Token----------${googleAuth.accessToken}");
      print("Token---------${googleUser.email.toString()}");
      final value = await FirebaseAuth.instance.signInWithCredential(
          credential);
      log(value.credential!.accessToken!);
      final User? user = value.user;
      if (user != null) {
        userName.value = user.displayName.toString();
        email.value = user.email.toString();
        photo.value = user.photoURL.toString();
        print("name or email"+user.email.toString()+user.displayName.toString());
        Get.to(() => const SuccessScreen());
      } else {
        print("e+++++");
      }
    }catch(e){
      print("erroororr"+e.toString());
    }
  }

  sendOtp() async {
    isLoading.value = true;

    try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91' + mobileNumberController.text,
          verificationCompleted:
              (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            isLoading.value = false;
            // reusable().showMessage(context,"OTP not send. Please try again");
          },
          codeSent:
              (String verificationId, int? resendToken) {
                isLoading.value = false;
               print('codesent');
            String verification = verificationId;
            print(verification);

                Get.to(() => OtpScreen(mobileNo: mobileNumberController.text, verificationID: verification,));
            // Get.to(() =>  Otpscreen(verification: verification, mobileNumber: phoneNumber.text.toString(), dialCode: dialCode,));
          },
          codeAutoRetrievalTimeout:
              (String verificationId) {
          },
        );
      } catch (e) {
      isLoading.value = false;
        print("otp not sent");
      }
  }

  void checkValidOtp() async {
    print(otpController.text);
    isLoading.value = true;

    try {
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
          verificationId: verificationID!,
          smsCode: otpController.text);
      print("credential : $credential");

      UserCredential userCredential = await auth.signInWithCredential(credential);
      await auth.signInWithCredential(credential);

      print("userCredential : $userCredential");
      String? uid = userCredential.user?.uid;
      print("uid : $uid");
      checkAlreadyAccount(uid!);

    } catch (e) {
      isLoading.value = false;
      // Utils().snackBar(context,"Invalid OTP");
    }
  }

  checkAlreadyAccount(String uid) async {
    final _dbref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot  snapshot = await _dbref.get();
    Map usersMap = snapshot.value as Map;
    bool isAlreadyAccount = false;

    usersMap.forEach((key, value) {
      int? number = int.tryParse(mobileNumberController.text.toString());
      if(number == value['MobileNo']) {
        isAlreadyAccount = true;
      }
    });

    if(isAlreadyAccount) {
      _dbRef.child(uid!).set({
        "CountryCode" : 'IN',
        "DialCode" : "+91",
        "MobileNo" : mobileNumberController.text,
        "createdAt" : getCurrentTime(),
        'userId' : uid,
      });
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
    Get.to(()=>SuccessScreen());
  }

}
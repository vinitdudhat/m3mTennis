
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/screens/authentication/otp_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';

class LoginController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString photo = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey();
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
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + mobileNumberController.text,
        verificationCompleted:
            (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false.obs;
          Utils().snackBar('OTP',"OTP not send. Please try again");
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading = false.obs;
          print('codesent');
          String verification = verificationId;
          print(verification);

          Get.to(() => OtpScreen(mobileNo: mobileNumberController.text,));
          // Get.to(() =>  Otpscreen(verification: verification, mobileNumber: phoneNumber.text.toString(), dialCode: dialCode,));
        },
        codeAutoRetrievalTimeout:
            (String verificationId) {
        },
      );
    } catch (e) {
      print("otp not sent");
    }
  }

}
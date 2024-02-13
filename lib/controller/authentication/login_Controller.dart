import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/repository/common_function.dart';
import 'package:m3m_tennis/repository/const_pref_key.dart';
import 'package:m3m_tennis/screens/authentication/otp_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController mobileNumberController1 = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString photo = ''.obs;
  String id = '';
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> formKey1 = GlobalKey();
  String? verificationID;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref('Users');


  sendOtp(String mobileNumber) async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + mobileNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Utils().snackBar(message: "Something went wrong. Please try again.");
          // Utils().snackBar(message: e.toString());

          // reusable().showMessage(context,"OTP not send. Please try again");
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading.value = false;
          print('codesent');
          String verification = verificationId;
          print(verification);
          verificationID = verificationId;

          Utils().snackBar(message: "OTP send to your mobile number.");
          Get.to(() => OtpScreen(
                mobileNo: mobileNumber,
                verificationID: verification,
              ));
          mobileNumberController.clear();

          // Get.to(() =>  Otpscreen(verification: verification, mobileNumber: phoneNumber.text.toString(), dialCode: dialCode,));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      isLoading.value = false;
      Utils().snackBar(message: "Something went wrong. Please try again.");
      print("otp not sent");
    }
  }

  void checkValidOtp() async {
    print(otpController.text);
    isLoading1.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID!, smsCode: otpController.text);
      print("credential : $credential");

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      // await auth.signInWithCredential(credential);

      print("userCredential : $userCredential");
      String? uid = userCredential.user?.uid;
      id = userCredential.user!.uid;
      print("id" + id.toString());
      print("uid : $uid");

      checkAlreadyAccount(uid!);
    } catch (e) {
      isLoading1.value = false;
    }
  }

  checkAlreadyAccount(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final _dbref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await _dbref.get();
    if(snapshot.value != null) {
      Map usersMap = snapshot.value as Map;
      bool isAlreadyAccount = false;

      usersMap.forEach((key, value) {
        String? number = mobileNumberController1.text.toString();
        if (number == value['MobileNo']) {
          isAlreadyAccount = true;
        }
      });

      if (isAlreadyAccount) {
        isLoading1.value = false;
      } else {
        _dbRef.child(uid!).update({
          "CountryCode": 'IN',
          "DialCode": "+91",
          "MobileNo": mobileNumberController1.text,
          "createdAt": getCurrentTime(),
          "UserName": "",
          "Email": "",
          "ProfilePic": null,
          'userId': uid,
        });
        isLoading1.value = false;
      }
      mobileNumberController1.clear();
      otpController.clear();
      prefs.setString(SharedPreferenKey.userId, uid!);
      prefs.setBool(SharedPreferenKey.isLogin, true);
      Get.offAll(() => SuccessScreen());
    } else {
      _dbRef.child(uid!).set({
        "CountryCode": 'IN',
        "DialCode": "+91",
        "MobileNo": mobileNumberController1.text,
        "createdAt": getCurrentTime(),
        "UserName": "",
        "Email": "",
        "ProfilePic": null,
        'userId': uid,
      });
      isLoading1.value = false;
      mobileNumberController1.clear();
      otpController.clear();

      prefs.setString(SharedPreferenKey.userId, uid!);
      prefs.setBool(SharedPreferenKey.isLogin, true);
      Get.offAll(() => SuccessScreen());
    }
  }

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
      final value =
      await FirebaseAuth.instance.signInWithCredential(credential);
      log(value.credential!.accessToken!);
      final User? user = value.user;
      print("user : $user");

      if (user != null) {
        id = value.user!.uid;
        print("id********" + id.toString());
        checkAlreadyAccountGoogle(id, user.email.toString(),
            user.displayName.toString(), user.photoURL.toString());

      } else {
        Utils().snackBar(message:"Something went wrong. Please try again.");
        print("e+++++");
      }
    } catch (e) {
      Utils().snackBar(message: "Something went wrong. Please try again.");
      // Utils().snackBar(message: e.toString());
      print("erroororr" + e.toString());
    }
  }

  checkAlreadyAccountGoogle(
      String uid, String email, String userName, String profile) async {
    final prefs = await SharedPreferences.getInstance();

    final _dbref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot snapshot = await _dbref.get();

    if(snapshot.value != null) {
      Map usersMap = snapshot.value as Map;
      bool isAlreadyAccount = false;

      usersMap.forEach((key, value) {
        if (email == value['Email']) {
          isAlreadyAccount = true;
        }
      });

      if (!isAlreadyAccount) {
        _dbRef.child(uid!).set({
          "CountryCode": 'IN',
          "DialCode": "+91",
          "createdAt": getCurrentTime(),
          "UserName": userName,
          "Email": email,
          "ProfilePic": profile,
          'userId': uid,
        });
        // });
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
      mobileNumberController1.clear();
      otpController.clear();
      Utils().snackBar(message:"Login Successfull");
      prefs.setString(SharedPreferenKey.userId, uid!);
      prefs.setBool(SharedPreferenKey.isLogin, true);
      Get.offAll(() => SuccessScreen());
    } else {
      _dbRef.child(uid!).set({
        "CountryCode": 'IN',
        "DialCode": "+91",
        "createdAt": getCurrentTime(),
        "UserName": userName,
        "Email": email,
        "ProfilePic": profile,
        'userId': uid,
      });
      // });
      isLoading.value = false;
      Utils().snackBar(message:"Login Successfull");
      prefs.setString(SharedPreferenKey.userId, uid!);
      prefs.setBool(SharedPreferenKey.isLogin, true);
      Get.offAll(() => SuccessScreen());
    }

  }
}

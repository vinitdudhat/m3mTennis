
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey();
  String? verificationID;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref('Users');



  sendOtp(String mobileNumber) async {
    isLoading.value = true;

    try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91' + mobileNumber,
          verificationCompleted:
              (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            isLoading.value = false;

            Utils().snackBar("", e.toString());

            // reusable().showMessage(context,"OTP not send. Please try again");
          },
          codeSent:
              (String verificationId, int? resendToken) {
                isLoading.value = false;
               print('codesent');
            String verification = verificationId;
            print(verification);

                Get.to(() => OtpScreen(mobileNo: mobileNumber, verificationID: verification,));
                mobileNumberController.clear();

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
    final prefs = await SharedPreferences.getInstance();

    final _dbref = FirebaseDatabase.instance.ref().child('Users');
    DataSnapshot  snapshot = await _dbref.get();
    Map usersMap = snapshot.value as Map;
    bool isAlreadyAccount = false;

    usersMap.forEach((key, value) {
      int? number = int.tryParse(mobileNumberController1.text.toString());
      if(number == value['MobileNo']) {
        isAlreadyAccount = true;
      }
    });

    if(!isAlreadyAccount) {
      _dbRef.child(uid!).set({
        "CountryCode" : 'IN',
        "DialCode" : "+91",
        "MobileNo" : mobileNumberController1.text,
        "createdAt" : getCurrentTime(),
        'userId' : uid,
      });
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
    mobileNumberController1.clear();
    otpController.clear();

    prefs.setString(SharedPreferenKey.userId, uid!);
    prefs.setBool(SharedPreferenKey.isLogin, true);
    Get.to(()=>SuccessScreen());
  }

}
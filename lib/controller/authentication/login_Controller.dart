
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/screens/authentication/otp_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';

class LoginController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey();
  String? verificationID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  sendOtp() async {
    isLoading.value = true;

    try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91' + mobileNumberController.text,
          verificationCompleted:
              (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
              isLoading = false.obs;
              update();
            // reusable().showMessage(context,"OTP not send. Please try again");
          },
          codeSent:
              (String verificationId, int? resendToken) {
                isLoading = false.obs;
                update();
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
        isLoading = false.obs;
        print("otp not sent");
      }
  }

  void checkValidOtp() async {
    print(otpController.text);

    try {
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
          verificationId: verificationID!,
          smsCode: otpController.text);
      print("credential : $credential");

      await auth.signInWithCredential(credential);
      Get.to(()=>SuccessScreen());

    } catch (e) {
      // Utils().snackBar(context,"Invalid OTP");
    }
  }


}
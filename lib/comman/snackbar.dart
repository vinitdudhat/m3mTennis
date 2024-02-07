import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';



class Utils{

  void snackBar({String title = '', required String message}){
    // Get.snackbar(
    //     title, message,
    //     reverseAnimationCurve: Curves.bounceIn,
    //     forwardAnimationCurve: Curves.bounceInOut,
    //     snackPosition: SnackPosition.TOP,
    //     duration: const Duration(seconds: 2),
    //     colorText: Colors.white,
    //     backgroundColor: ConstColor.primaryColor);

    Get.snackbar(
      // message,
      '',
      '',
      titleText: Text(message, style: ConstFontStyle().buttonTextStyle!.copyWith(color: ConstColor.primaryColor),),
      messageText: Container(),
      // Text(message, style: ConstFontStyle().buttonTextStyle,),
      colorText: ConstColor.primaryColor,
      snackPosition: SnackPosition.TOP,
      backgroundColor: ConstColor.white,
      // borderWidth: 1.5,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20,top: 25),
      duration: Duration(seconds: 1),
    );
  }




}
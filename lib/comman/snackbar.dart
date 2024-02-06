import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constColor.dart';



class Utils{

  void snackBar(String title,String message){

    Get.snackbar(title, message,
        reverseAnimationCurve: Curves.bounceIn,
        forwardAnimationCurve: Curves.bounceInOut,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: ConstColor.primaryColor);
  }


}
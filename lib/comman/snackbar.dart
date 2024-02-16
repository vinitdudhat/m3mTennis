import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';



class Utils{

  void snackBar({String title = '', required String message}){
    Get.snackbar('',
      '',
      titleText: Text(message, style: ConstFontStyle().buttonTextStyle!.copyWith(color: ConstColor.primaryColor,fontWeight: FontWeight.w500),),
      messageText: Container(),
      // Text(message, style: ConstFontStyle().buttonTextStyle,),
      colorText: ConstColor.backGroundColor,
      snackPosition: SnackPosition.TOP,
      // borderRadius: BorderRadius.circular(15),
      animationDuration: Duration(seconds: 1),
      backgroundColor: Colors.white/*ConstColor.backGroundColor*/,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20,top: 25),
      duration: Duration(milliseconds: 1500),
    );
  }




}
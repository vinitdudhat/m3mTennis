
import 'package:flutter/material.dart';

import 'constColor.dart';
import 'const_fonts.dart';

class ConstFontStyle{

  final TextStyle mainTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: ConstFont.popinsRegular,
  );

  final TextStyle titleTextStyle1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: ConstColor.white,
    fontFamily: ConstFont.popinsBold,
  );
  
  final TextStyle mainTextStyle1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: ConstColor.greyTextColor,
    fontFamily: ConstFont.popinsBold,
  );
  
  final TextStyle mainTextStyle2 = TextStyle(
    fontSize: 24,
    color: ConstColor.greyTextColor,
    fontFamily: ConstFont.popinsBold,
  );

  final TextStyle mainTextStyle3 = TextStyle(
    fontSize: 12,
    color: ConstColor.greyTextColor,
    fontFamily: ConstFont.popinsRegular,
  );

  final TextStyle italicTextTitle = TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 20,
      color: ConstColor.greyTextColor
  );

  final TextStyle buttonTextStyle = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 16,
      color: ConstColor.greyTextColor
  );

  final TextStyle titleText = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 16,
      color: ConstColor.white
  );

  final TextStyle smallText = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 10,
      color: ConstColor.white
  );

  final TextStyle titleText1 = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      color: ConstColor.white
  );

  final TextStyle lableTextStyle = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 18,
      color: ConstColor.greyTextColor
  );

  final TextStyle textStyle1 = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 14,
      color: ConstColor.black
  );


  final TextStyle headline1 = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 12,
      color: ConstColor.primaryColor
  );

  final TextStyle headline2 = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 14,
      color: ConstColor.primaryColor
  );

  final TextStyle highlight1 = TextStyle(
      fontFamily: ConstFont.popinsRegular,
      fontSize: 14,
      color: ConstColor.errorColor
  );

}
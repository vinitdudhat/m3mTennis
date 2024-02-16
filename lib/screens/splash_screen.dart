import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constAsset.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/repository/const_pref_key.dart';
import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
import 'package:m3m_tennis/screens/dashboard/home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const   SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 2), () => whereToGo());
    super.initState();
  }

  whereToGo() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool(SharedPreferenKey.isLogin);

    if(isLoggedIn != null && isLoggedIn) {
        Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      body: Center(
        child: SizedBox(
            height: deviceHeight * 0.15,
            width: deviceWidth * 0.6,
            child: Image.asset(ConstAsset.logoImage)
        ),
      ),
    );
  }
}

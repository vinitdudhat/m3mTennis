
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:m3m_tennis/comman/constAsset.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/controller/authentication/login_Controller.dart';
import '../../comman/constColor.dart';
import '../../widget/button_widget.dart';
import 'mobileNum_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    var deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.04),
              child: SizedBox(
                  height: deviceHeight * 0.13,
                  width: deviceWidth * 0.5,
                  child: Image.asset(ConstAsset.logoImage)),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text(
                "TENNIS COURT BOOKING",
                style: ConstFontStyle().mainTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.025),
              child: Text(
                  "'' Each new day is a new opportunity to improve yourself.",
                  textAlign: TextAlign.center,
                  style: ConstFontStyle().italicTextTitle),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.022),
              child: Container(
                  height: deviceHeight * 0.4,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    ConstAsset.loginImage,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.04),
              child: RoundButtonWithIcon(
                onTap: () {
                  Get.to(() => MobileNumScreen());
                },
                title: 'Login with Mobile OTP',
                image: ConstAsset.mobileIcon,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: deviceHeight * 0.02),
            //   child: RoundButtonWithIcon(
            //     onTap: () {
            //       loginController.signInWithGoogle();
            //     },
            //     title: 'Login with e-mail',
            //     image: ConstAsset.emailIcon,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }




}

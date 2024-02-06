import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../dashboard/home_Screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(
    //   Duration(seconds: 3),
    //   () {
    //     Get.to(() => HomeScreen());
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.07),
                child: Icon(
                  Icons.check_circle,
                  color: ConstColor.primaryColor,
                  size: 70,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.3),
                child: Text(
                  "SUCCESS!!",
                  style: ConstFontStyle().mainTextStyle1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.02),
                child: Text(
                  "Congrats! You have been \nsuccessfully authenticated.",
                  textAlign: TextAlign.center,
                  style: ConstFontStyle()
                      .mainTextStyle
                      .copyWith(color: ConstColor.greyTextColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Redirecting to your booking screen",
                      textAlign: TextAlign.center,
                      style: ConstFontStyle().buttonTextStyle,
                    ),
                    Countdown(
                      build: (BuildContext context, double time) =>
                          Text(time.toString(),style : ConstFontStyle().buttonTextStyle),
                      interval: Duration(milliseconds: 100),
                      onFinished: () {
                        Get.offAll(() => HomeScreen());
                        print('Timer is done!');
                      },
                      seconds: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

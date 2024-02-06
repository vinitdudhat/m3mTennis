import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../comman/constAsset.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';
import '../../comman/const_fonts.dart';
import '../../controller/authentication/login_Controller.dart';
import '../../widget/button_widget.dart';
import '../../widget/textformField_widget.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNo;
  final String verificationID;
  OtpScreen({super.key,required this.mobileNo, required this.verificationID});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  LoginController loginController = Get.put(LoginController());
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginController.mobileNumberController.text = widget.mobileNo.toString();
    loginController.verificationID = widget.verificationID;
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstColor.backGroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.08),
                  child: SizedBox(
                      height: deviceHeight * 0.13,
                      width: deviceWidth * 0.5,
                      child: Image.asset(ConstAsset.logoImage)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.09),
                  child: Text(
                    'Enter the 6 digit number that \n was sent to the below number',
                    textAlign: TextAlign.center,
                    style: ConstFontStyle()
                        .mainTextStyle
                        .copyWith(color: ConstColor.greyTextColor),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        right: deviceWidth * 0.06,
                        left: deviceWidth * 0.06,
                        top: deviceHeight * 0.08),
                    child: CommonTextfield(
                      obSecure: false,
                      readOnly: true,
                      controller: loginController.mobileNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      labelText: "Mobile Number",
                      keyboardType: TextInputType.number,
                      prefix: ConstAsset.mobileIcon,
                      suffixIcon: Icon(
                        Icons.edit_outlined,
                        color: ConstColor.primaryColor,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.1, right: deviceWidth * 0.06,
                    left: deviceWidth * 0.06, ),
                  child: PinCodeTextField(
                    controller: loginController.otpController,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: ConstColor.greyTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: ConstFont.popinsMedium
                    ),
                    length: 6,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    // validator: (v) {
                    //   if (v!.length < 6) {
                    //     return "I'm from validator";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: ConstColor.greyTextColor,
                      activeFillColor: ConstColor.greyTextColor,
                      inactiveColor: ConstColor.greyTextColor,
                        selectedColor : ConstColor.greyTextColor
                    ),
                    cursorColor: ConstColor.greyTextColor,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: false,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.06),
                  child: RoundButton(
                    title: 'Verify',
                    onTap: () {
                      loginController.checkValidOtp();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Re-send code in ",
                        style: ConstFontStyle().buttonTextStyle,
                      ),
                      Countdown(
                        build: (BuildContext context, double time) =>
                            Text(time.toString(),style : ConstFontStyle().buttonTextStyle),
                        interval: Duration(milliseconds: 100),
                        onFinished: () {
                          print('Timer is done!');
                        },
                        seconds: 60,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

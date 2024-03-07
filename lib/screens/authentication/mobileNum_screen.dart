
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/controller/authentication/login_Controller.dart';
import '../../comman/constAsset.dart';
import '../../comman/constFontStyle.dart';
import '../../widget/button_widget.dart';
import '../../widget/textformField_widget.dart';

class MobileNumScreen extends StatefulWidget {
  const MobileNumScreen({super.key});

  @override
  State<MobileNumScreen> createState() => _MobileNumScreenState();
}

class _MobileNumScreenState extends State<MobileNumScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.06),
                child: SizedBox(
                    height: deviceHeight * 0.13,
                    width: deviceWidth * 0.5,
                    child: Image.asset(ConstAsset.logoImage)),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.09),
                child: Text(
                  'To continue enter your phone number',
                  style: ConstFontStyle()
                      .mainTextStyle
                      .copyWith(color: ConstColor.greyTextColor),
                ),
              ),

              Padding(
                  padding: EdgeInsets.only(
                      right: deviceWidth * 0.06,
                      left: deviceWidth * 0.06,
                      top: deviceHeight * 0.3),
                  child: Form(
                    key: loginController.formKey,
                    child: PhoneNoField(
                      controller: loginController.mobileNumberController,
                      codeChange: (phone, countryCode) {
                        setState(() {
                          loginController.countryCodeController.value.text = countryCode;
                          loginController.phoneController.value.text = phone;
                          print("countryCode"+countryCode.toString());
                          print("phone"+phone.toString());

                        });
                      },
                      countryCode: loginController.countryCode,
                    ),

                    /*CommonTextfield(
                      controller: loginController.mobileNumberController,
                      obSecure: false,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      labelText: "Mobile Number",
                      keyboardType: TextInputType.number,
                      prefix: ConstAsset.mobileIcon,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter mobile number'),
                        LengthRangeValidator(
                            min: 10,
                            max: 10,
                            errorText: "Please enter at least 10 character"),
                      ]),
                    ),*/
                  )),
              Obx(
                () {
                  return Padding(
                    padding: EdgeInsets.only(top: deviceHeight * 0.06),
                    child: RoundButton(
                      title: 'Send OTP',
                      onTap: loginController.isLoading.value
                          ? () => null
                          : () {
                              if (loginController.formKey.currentState!
                                  .validate()) {
                                // loginController.checkNumberRegister();
                                print("countryCode"+loginController.countryCodeController.value.text,);
                                loginController.sendOtp(
                                    loginController.countryCodeController.value.text,
                                    loginController.mobileNumberController.text);
                              }
                            },
                      loading: loginController.isLoading.value,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/confirmationCard.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/screens/booking/myBooking%20_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/booking/mybooking_Controller.dart';
import '../../widget/textformField_widget.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final int courtId;
  final String date;
  final String slot;

  const ConfirmBookingScreen({super.key, required this.courtId, required this.date, required this.slot});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  MyBookingController myBookingController = Get.put(MyBookingController());
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: ConstColor.greyTextColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.02, vertical: deviceHeight * 0.01),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.03),
                  child: Icon(
                    Icons.check_circle,
                    color: ConstColor.primaryColor,
                    size: 70,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.02),
                child: Center(
                    child: Text(
                  "Booking Confirmed",
                  style: ConstFontStyle().mainTextStyle2,
                )),
              ),
             Padding(
               padding: EdgeInsets.only(top: deviceHeight * 0.01),
               child: CommonConfirmationCard(courtNumber: "Court #${widget.courtId}",date: widget.date,time: widget.slot),
               // CommonConfirmationCard(courtNumber: "Court #1",date: "13 Jan 2024",time: "11 - 12 am"),
             ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.04),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ConstColor.primaryColor,
                      radius: 15,
                      child: Icon(
                        Icons.add,
                        color: ConstColor.backGroundColor,
                      ),
                    ),
                    Text(
                      "   You can invite up to 3 members",
                      style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.02),
                child: Card(
                  color: ConstColor.cardBackGroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4),
                    dashPattern: [10, 10],
                    color: ConstColor.borderColor,
                    strokeWidth: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Aditi Sharma",
                            style: ConstFontStyle().buttonTextStyle,
                          ),
                          Text(
                            "      (Host)",
                            style: ConstFontStyle()
                                .buttonTextStyle
                                .copyWith(fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.015,
                    right: deviceWidth * 0.01,
                    left: deviceWidth * 0.01),
                child: InviteField(
                  obSecure: false,
                  hintText: "Member1",
                  controller: myBookingController.member1,
                  suffix: InkWell(
                    onTap: (){
                      myBookingController.member1.clear();
                    },
                    child: Text("Remove",style: ConstFontStyle().mainTextStyle.copyWith(
                        color: ConstColor.primaryColor,
                        fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.015,
                    right: deviceWidth * 0.01,
                    left: deviceWidth * 0.01),
                child: InviteField(
                  obSecure: false,
                  hintText: "Member2",
                  controller: myBookingController.member2,
                  suffix: InkWell(
                    onTap: (){
                      myBookingController.member2.clear();
                    },
                    child: Text("Remove",style: ConstFontStyle().mainTextStyle.copyWith(
                        color: ConstColor.primaryColor,
                        fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.015,
                    right: deviceWidth * 0.01,
                    left: deviceWidth * 0.01),
                child: InviteField(
                  obSecure: false,
                  hintText: "Member3",
                  controller: myBookingController.member3,
                  suffix: InkWell(
                    onTap: (){
                      myBookingController.member3.clear();
                    },
                    child: Text("Remove",style: ConstFontStyle().mainTextStyle.copyWith(
                        color: ConstColor.primaryColor,
                        fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.05),
                child: GestureDetector(
                  onTap: (){
                    openWhatsApp();
                    // Get.to(()=> MyBookingScreen());
                  },
                  child: Center(
                    child: Text(
                      "Invite Later",
                      style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  openWhatsApp() async{
    var androidUrl = "whatsapp://send?phone&text=Hi, You are Invited to play Badminton.";
    try{
      await launchUrl(Uri.parse(androidUrl));
    } on Exception{
      print('WhatsApp is not installed.');
    }
  }
}

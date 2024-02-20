import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/confirmationCard.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/widget/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/booking/mybooking_Controller.dart';
import '../../widget/textformField_widget.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final String userName;
  final String courtId;
  final String date;
  final String slot;
  final String bookingId;

  const ConfirmBookingScreen(
      {super.key,
      required this.courtId,
      required this.date,
      required this.slot,
      required this.bookingId,
      required this.userName});

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
            horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.01),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: CommonConfirmationCard(
                    courtNumber: widget.courtId,
                    date: widget.date,
                    time: widget.slot),
                // CommonConfirmationCard(courtNumber: "Court #1",date: "13 Jan 2024",time: "11 - 12 am"),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.04),
                child: GestureDetector(
                  onTap: () {
                    openWhatsApp();
                  },
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
                      SizedBox(width: 10,),
                      Text(
                        "You can invite up to 3 members",
                        style: ConstFontStyle().mainTextStyle.copyWith(
                            color: ConstColor.greyTextColor,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.02,right: deviceWidth * 0.01,
                    left: deviceWidth * 0.01),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [6, 6],
                  color: Colors.white30,
                  strokeWidth: 1.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ConstColor.cardBackGroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: deviceWidth * 0.7,
                            // color: Colors.grey,
                            child: Text(
                              widget.userName,
                              // "Aditi Sharma Aditi Sharma Aditi Sharma Aditi Sharma Aditi Sharma Aditi Sharma",
                              style: ConstFontStyle().buttonTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "(Host)",
                            style: ConstFontStyle()
                                .buttonTextStyle
                                .copyWith(fontWeight: FontWeight.w300,color: ConstColor.greyTextColor!.withOpacity(0.7)),
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
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [6, 6],
                  strokeWidth: 1.5,
                  color: Colors.white30,
                  child: InviteField(
                    obSecure: false,
                    hintText: "Member1",
                    controller: myBookingController.member1,
                    suffix: InkWell(
                      onTap: () {
                        myBookingController.member1.clear();
                      },
                      child: Text(
                        "Remove",
                        style: ConstFontStyle().mainTextStyle.copyWith(
                            color: ConstColor.primaryColor,
                            fontWeight: FontWeight.w400),
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
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [6, 6],
                  strokeWidth: 1.5,
                  color: Colors.white30,
                  child: InviteField(
                    obSecure: false,
                    // readOnly: myBookingController.member1.text == '' ? true : false,
                    // onTap: () {
                    //   if(myBookingController.member1.text == '') {
                    //
                    //   } else {
                    //
                    //   }
                    // },
                    hintText: "Member2",
                    controller: myBookingController.member2,
                    suffix: InkWell(
                      onTap: () {
                        myBookingController.member2.clear();
                      },
                      child: Text(
                        "Remove",
                        style: ConstFontStyle().mainTextStyle.copyWith(
                            color: ConstColor.primaryColor,
                            fontWeight: FontWeight.w400),
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
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  dashPattern: [6, 6],
                  strokeWidth: 1.5,
                  color: Colors.white30,
                  child: InviteField(
                    obSecure: false,
                    hintText: "Member3",
                    controller: myBookingController.member3,
                    suffix: InkWell(
                      onTap: () {
                        myBookingController.member3.clear();
                      },
                      child: Text(
                        "Remove",
                        style: ConstFontStyle().mainTextStyle.copyWith(
                            color: ConstColor.primaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.04),
                child: GestureDetector(
                  onTap: () {
                    if (myBookingController.member1.text.isNotEmpty || myBookingController.member2.text.isNotEmpty || myBookingController.member3.text.isNotEmpty ) {
                      myBookingController.addMemberInBooking(
                          bookingId: widget.bookingId);
                    } else {
                      Utils().snackBar(
                          message: "Please enter at least 1 member name.");
                    }
                  },
                  child: Container(
                    height: deviceHeight * 0.05,
                    width: deviceWidth * 0.5,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: ConstColor.primaryColor)
                    ),
                    child: Center(
                      child: Text(
                          "Add Member",
                          style: ConstFontStyle()
                              .mainTextStyle
                              .copyWith(
                              color:  ConstColor.primaryColor)
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: deviceHeight * 0.04),
              //   child: RoundButton(
              //     title: 'Add to Calender',
              //     onTap: () {
              //       if (myBookingController.member1.text.isNotEmpty || myBookingController.member2.text.isNotEmpty || myBookingController.member3.text.isNotEmpty ) {
              //         myBookingController.addMemberInBooking(
              //             bookingId: widget.bookingId);
              //       } else {
              //         Utils().snackBar(
              //             message: "Please enter at least 1 member name.");
              //       }
              //     },
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.03),
                child: GestureDetector(
                  onTap: () {
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
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  openWhatsApp() async {
    var androidUrl =
        "whatsapp://send?phone&text=Hi, You are Invited to play Badminton.";
    try {
      await launchUrl(Uri.parse(androidUrl));
    } on Exception {
      print('WhatsApp is not installed.');
    }
  }
}

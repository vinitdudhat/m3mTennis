import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';

class BookingCriteriaScreen extends StatefulWidget {
  const BookingCriteriaScreen({super.key});

  @override
  State<BookingCriteriaScreen> createState() => _BookingCriteriaScreenState();
}

class _BookingCriteriaScreenState extends State<BookingCriteriaScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text(
          "Booking Criteria",
          style: ConstFontStyle().titleText,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ConstColor.greyTextColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02,horizontal: deviceWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Text("Bookings cannot be made more than 24 hours in advance.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("Each booking for a given person cannot extend beyond 1 hour.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("A given user can only have one active booking for a given day.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("Children coaching timings auto blocked - Recurring booking.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("Person who has booking can cancel the booking anytime.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("Anyone can see others booking but cannot edit them until it is the admin.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Text("Cancellations are allowed, but a notification will be triggered to all users.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.025),
              child: Text("HAVE FUN PLAYING.",style:  ConstFontStyle().mainTextStyle.copyWith(
                color: ConstColor.greyTextColor,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

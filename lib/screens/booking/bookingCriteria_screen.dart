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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ConstColor.white,
            size: 18,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02,horizontal: deviceWidth * 0.1),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Text("Bookings cannot be made more than 24 hours in advance.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("Each booking for a given person cannot extend beyond 1 hour.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("A given user can only have one active booking for a given day.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("Children coaching timings auto blocked - Recurring booking.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("Person who has booking can cancel the booking anytime.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("Anyone can see others booking but cannot edit them until it is the admin.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),

            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Text("Cancellations are allowed, but a notification will be triggered to all users.",maxLines: 2,style: ConstFontStyle().mainTextStyle.copyWith(
              color: ConstColor.greyTextColor,
            ),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
              child: Divider(
                color: ConstColor.greyTextColor,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.015),
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

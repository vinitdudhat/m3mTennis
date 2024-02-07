import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../comman/bookingStatusCard.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';
import '../../comman/const_fonts.dart';
import '../../controller/booking/mybooking_Controller.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  MyBookingController myBookingController = Get.put(MyBookingController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(myBookingController.isActive.toString());
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text(
          "My Booking",
          style: ConstFontStyle().titleText,
        ),
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
      backgroundColor: ConstColor.backGroundColor,
      body: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02,vertical: deviceHeight * 0.01),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      myBookingController.isActive.value = 2;
                    },
                    child: Container(
                      height: deviceHeight * 0.07,
                      width: deviceWidth * 0.35,
                      decoration: BoxDecoration(
                          color: myBookingController.isActive.value == 2
                              ? ConstColor.primaryColor
                              : ConstColor.cardBackGroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16)
                          )),
                      child: Center(
                        child: Text(
                          "Upcoming",
                          style: ConstFontStyle().mainTextStyle.copyWith(
                              color: myBookingController.isActive.value == 2
                                  ? ConstColor.black : ConstColor.greyTextColor),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookingController.isActive.value = 1;
                    },
                    child: Container(
                      height: deviceHeight * 0.07,
                      width: deviceWidth * 0.35,
                      decoration: BoxDecoration(
                          color: myBookingController.isActive.value == 1
                              ? ConstColor.primaryColor
                              : ConstColor.cardBackGroundColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16)
                          )),
                      child: Center(
                        child: Text(
                          "Completed",
                          style: ConstFontStyle().mainTextStyle.copyWith(
                              color: myBookingController.isActive.value == 1
                                  ? ConstColor.black
                                  : ConstColor.greyTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              myBookingController.isActive.value == 1 ?
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: BookingStatusCard(courtNo: "Court #1", cDate: "12 Mar 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
              ) : SizedBox(),

            myBookingController.isActive.value == 2 ?
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: BookingStatusCard(courtNo: "Court #2", cDate: "18 jan 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
              ) : SizedBox(),

              myBookingController.isActive.value == 2 ?
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: BookingStatusCard(courtNo: "Court #1", cDate: "22 Fab 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

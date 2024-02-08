
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/repository/common_function.dart';
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
        centerTitle: true,
        title: Text(
          "My Bookings",
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
          child: SingleChildScrollView(
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


                StreamBuilder(
                  stream: myBookingController.dbref.child('User_Bookings').orderByChild('userId').equalTo(myBookingController.auth.currentUser?.uid).onValue,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) {
                      return Container();
                    } else {
                      Map? bookData = snapshot.data!.snapshot.value as Map?;
                      print("bookData : $bookData");

                      List upcomingBooking = [];
                      List completedBooking = [];

                      DateTime currentTime = DateTime.now();

                      if(bookData != null) {
                        bookData.forEach((key, value) {
                          print(value);
                          List<String> dateComponents = value["date"].toString().substring(0, 10).split("-");
                          int year = int.parse(dateComponents[0]);
                          int month = int.parse(dateComponents[1]);
                          int day = int.parse(dateComponents[2]);

                          String toTime = convertTo24HourFormat(value["to"]);
                          print("toTime000 : $toTime");

                          List<String> timeHours = toTime.split(':');
                          DateTime targetTime = DateTime(
                            year,
                            month,
                            day,
                            int.parse(timeHours[0]),
                            int.parse(timeHours[1]),
                          );
                          bool isCompleted = currentTime.isAfter(targetTime);
                          print("isCompleted : $isCompleted");

                          if(!isCompleted) {
                            upcomingBooking.add(value);
                          } else {
                            completedBooking.add(value);
                          }
                        });
                      }

                      return Column(
                        children: [
                          myBookingController.isActive.value == 1 ?
                          Container(
                            height: deviceHeight * 0.79,
                            width: deviceWidth,
                            padding: EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              itemCount: completedBooking.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = completedBooking[index];
                                int courtId = item['courtId'] == 'EC' ? 1 : 2 ;

                                DateTime dateTime =
                                DateTime.parse(item['date']);
                                String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
                                String slotTime = item['from'] + " - " + item['to'];

                                return BookingStatusCard(courtNo: "Court #$courtId", cDate: formattedDate, cTime: slotTime,inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024");
                              },
                            ),
                          )
                          // Padding(
                          //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                          //   child: BookingStatusCard(courtNo: "Court #1", cDate: "12 Mar 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                          // )
                              : SizedBox(),

                          myBookingController.isActive.value == 2 ?
                          Container(
                            height: deviceHeight * 0.79,
                            width: deviceWidth,
                            padding: EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              itemCount: upcomingBooking.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = upcomingBooking[index];
                                int courtId = item['courtId'] == 'EC' ? 1 : 2 ;

                                DateTime dateTime =
                                DateTime.parse(item['date']);
                                String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
                                String slotTime = item['from'] + " - " + item['to'];

                                return BookingStatusCard(courtNo: "Court #$courtId", cDate: formattedDate, cTime: slotTime,inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024");
                              },
                            ),
                          )
                          // Padding(
                          //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                          //   child: BookingStatusCard(courtNo: "Court #1", cDate: "12 Mar 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                          // )
                              : SizedBox(),
                        ],
                      );
                    }
                  },
                ),

              // myBookingController.isActive.value == 2 ?
              // StreamBuilder(
              //   stream: myBookingController.dbref.child('User_Bookings').orderByChild('userId').equalTo(myBookingController.auth.currentUser?.uid).onValue,
              //   builder: (context, snapshot) {
              //     if(!snapshot.hasData) {
              //       return Container();
              //     } else {
              //
              //
              //       return Container(
              //         height: deviceHeight * 0.79,
              //         width: deviceWidth,
              //         padding: EdgeInsets.only(top: 10),
              //         child: ListView.builder(
              //           itemCount: upcomingBooking.length,
              //           physics: NeverScrollableScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             var item = upcomingBooking[index];
              //             int courtId = item['courtId'] == 'EC' ? 1 : 2 ;
              //
              //             DateTime dateTime =
              //             DateTime.parse(item['date']);
              //             String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
              //             String slotTime = item['from'] + " - " + item['to'];
              //
              //             return BookingStatusCard(courtNo: "Court #$courtId", cDate: formattedDate, cTime: slotTime,inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024");
              //           },
              //         ),
              //       );
              //     }
              //   },
              // ) : Container()


                // SingleChildScrollView(
                //   child: Column(
                //     children: List.generate(
                //     2, (index) => BookingStatusCard(courtNo: "Court #2", cDate: "18 jan 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                //     )
                //   ),
                // ),

                // Padding(
                //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                //   child: BookingStatusCard(courtNo: "Court #2", cDate: "18 jan 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),) : SizedBox(),
                //
                // myBookingController.isActive.value == 2 ?
                // Padding(
                //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                //   child: BookingStatusCard(courtNo: "Court #1", cDate: "22 Fab 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                // ) : SizedBox(),
              ],
            ),
          )
        ),
      ),
    );
  }
}

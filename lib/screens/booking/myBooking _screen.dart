
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/repository/common_function.dart';
import 'package:m3m_tennis/screens/dashboard/home_Screen.dart';
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

                      return Container(
                        height: deviceHeight * 0.61,
                        width: deviceWidth,
                        // color: Colors.red,
                        padding: EdgeInsets.only(top: 5),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              myBookingController.isActive.value == 1 ?
                              completedBooking.length == 0 ? Container(
                                  height: deviceHeight * 0.55,
                                  width: deviceWidth,
                                  color: Colors.red,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.offAll(() => HomeScreen());
                                      },
                                      child: Text(
                                          "Book your 1st slot.",
                                          style:
                                          // ConstFontStyle().titleText,
                                          ConstFontStyle().titleText.copyWith(
                                              color: ConstColor.greyTextColor)
                                      ),
                                    ),
                                  )
                              ) : Column(
                                  children: List.generate(
                                      completedBooking.length,
                                          (index) {
                                        var item = completedBooking[index];
                                        // int courtId = item['courtId'] == 'EC' ? 1 : 2 ;
                                        String courtId = item['courtId'] == 'EC' ? "East Court" : "West Court" ;
                          
                                        String formattedDate = convertToShowingDateFormat(item['date']);
                                        String slotTime = item['from'] + " - " + item['to'];
                                        String bookingId = item['BookingId'];
                                        String bookedOn = convertToShowingDateFormat(item['createdAt']);
                                        List memberList = [];
                                        List inviteMemberKeyList = [];
                                        Map? memberMap = item['memberList'];
                                        // print("memberMap : $memberMap");
                          
                                        if(memberMap != null) {
                                          // memberList = memberMap.to
                                          memberList.addAll(memberMap.values);
                                          inviteMemberKeyList.addAll(memberMap.keys);
                                        }
                                        // print("memberList : $memberList");
                                        // print("inviteMemberKeyList : $inviteMemberKeyList");
                          
                                        return BookingStatusCard(courtNo: "$courtId",
                                            cDate: formattedDate,
                                            cTime: slotTime,
                                            inviteMemberList: memberList,
                                            inviteMemberKeyList: inviteMemberKeyList,
                                            bookingId: bookingId,bookingDate: bookedOn);
                                      }
                                  ),
                              ) : SizedBox(),
                          
                              myBookingController.isActive.value == 2 ?
                              upcomingBooking.length == 0 ? Container(
                                  height: deviceHeight * 0.55,
                                  width: deviceWidth,
                                  // color: Colors.red,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.offAll(() => HomeScreen());
                                      },
                                      child: Text(
                                        "Book your slot for the game.",
                                        style:
                                        // ConstFontStyle().titleText,
                                        ConstFontStyle().titleText.copyWith(
                                            color: ConstColor.greyTextColor),
                                      ),
                                    ),
                                  )
                              ) : Column(
                                children: List.generate(
                                  upcomingBooking.length,
                                        (index) {
                                          var item = upcomingBooking[index];
                                          // int courtId = item['courtId'] == 'EC' ? 1 : 2 ;
                                          String courtId = item['courtId'] == 'EC' ? "East Court" : "West Court" ;
                          
                                          String formattedDate = convertToShowingDateFormat(item['date']);
                                          String slotTime = item['from'] + " - " + item['to'];
                                          String bookingId = item['BookingId'];
                                          String bookedOn = convertToShowingDateFormat(item['createdAt']);
                          
                                          List memberList = [];
                                          List inviteMemberKeyList = [];
                                          Map? memberMap = item['memberList'];
                                          print("memberMap : $memberMap");
                          
                                          if(memberMap != null) {
                                            // memberList = memberMap.to
                                            memberList.addAll(memberMap.values);
                                            inviteMemberKeyList.addAll(memberMap.keys);
                                          }
                                          print("memberList : $memberList");
                                          print("inviteMemberKeyList : $inviteMemberKeyList");
                          
                                          return BookingStatusCard(courtNo: courtId,
                                            cDate: formattedDate,
                                            cTime: slotTime,
                                            inviteMemberList: memberList,
                                            inviteMemberKeyList: inviteMemberKeyList,
                                            bookingId: bookingId,bookingDate: bookedOn,isUpcoming: true,
                                            onTap: () => myBookingController.cancelBottomSheet(context: context,bookingId: bookingId, slotTime: slotTime),
                                          );
                                    }
                                ),
                              ) : SizedBox()
                          
                          
                          
                                              //       Container(
                                              //         height: deviceHeight * 0.55,
                                              //         width: deviceWidth,
                                              //         color: Colors.red,
                                              //         padding: EdgeInsets.only(top: 10),
                                              //         child: upcomingBooking.length == 0 ?
                                              //   Center(
                                              //   child: GestureDetector(
                                              //     onTap: () {
                                              //       Get.offAll(() => HomeScreen());
                                              //     },
                                              //     child: Text(
                                              //       "Book your 1st slot.",
                                              //       style:
                                              //       // ConstFontStyle().titleText,
                                              //         ConstFontStyle().titleText.copyWith(
                                              //             color: ConstColor.greyTextColor)
                                              //     ),
                                              //   ),
                                              // )
                                              //     :
                                              //         ListView.builder(
                                              //           itemCount: completedBooking.length,
                                              //           // physics: NeverScrollableScrollPhysics(),
                                              //           itemBuilder: (context, index) {
                                              //             var item = completedBooking[index];
                                              //             // int courtId = item['courtId'] == 'EC' ? 1 : 2 ;
                                              //             String courtId = item['courtId'] == 'EC' ? "East Court" : "West Court" ;
                                              //
                                              //             String formattedDate = convertToShowingDateFormat(item['date']);
                                              //             String slotTime = item['from'] + " - " + item['to'];
                                              //             String bookingId = item['BookingId'];
                                              //             String bookedOn = convertToShowingDateFormat(item['createdAt']);
                                              //             List memberList = [];
                                              //             List inviteMemberKeyList = [];
                                              //             Map? memberMap = item['memberList'];
                                              //             // print("memberMap : $memberMap");
                                              //
                                              //             if(memberMap != null) {
                                              //               // memberList = memberMap.to
                                              //               memberList.addAll(memberMap.values);
                                              //               inviteMemberKeyList.addAll(memberMap.keys);
                                              //             }
                                              //             // print("memberList : $memberList");
                                              //             // print("inviteMemberKeyList : $inviteMemberKeyList");
                                              //
                                              //             return BookingStatusCard(courtNo: "$courtId",
                                              //                 cDate: formattedDate,
                                              //                 cTime: slotTime,
                                              //                 inviteMemberList: memberList,
                                              //                 inviteMemberKeyList: inviteMemberKeyList,
                                              //                 bookingId: bookingId,bookingDate: bookedOn);
                                              //           },
                                              //         ),
                                              //       )
                              // Padding(
                              //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                              //   child: BookingStatusCard(courtNo: "Court #1", cDate: "12 Mar 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                              // )
                              //     : SizedBox(),
                          
                                              //       myBookingController.isActive.value == 2 ?
                                              //       Container(
                                              //         height: deviceHeight * 0.79,
                                              //         width: deviceWidth,
                                              //         padding: EdgeInsets.only(top: 10),
                                              //         child: upcomingBooking.length == 0 ?
                                              // Center(
                                              //   child: GestureDetector(
                                              //     onTap: () {
                                              //       Get.offAll(() => HomeScreen());
                                              //     },
                                              //     child: Text(
                                              //     "Book your spot for the game.",
                                              //     style:
                                              //     // ConstFontStyle().titleText,
                                              //     ConstFontStyle().titleText.copyWith(
                                              //         color: ConstColor.greyTextColor),
                                              //     ),
                                              //   ),
                                              // )
                                              //             : ListView.builder(
                                              //           itemCount: upcomingBooking.length,
                                              //           // physics: NeverScrollableScrollPhysics(),
                                              //           itemBuilder: (context, index) {
                                              //             var item = upcomingBooking[index];
                                              //             // int courtId = item['courtId'] == 'EC' ? 1 : 2 ;
                                              //             String courtId = item['courtId'] == 'EC' ? "East Court" : "West Court" ;
                                              //
                                              //             String formattedDate = convertToShowingDateFormat(item['date']);
                                              //             String slotTime = item['from'] + " - " + item['to'];
                                              //             String bookingId = item['BookingId'];
                                              //             String bookedOn = convertToShowingDateFormat(item['createdAt']);
                                              //
                                              //             List memberList = [];
                                              //             List inviteMemberKeyList = [];
                                              //             Map? memberMap = item['memberList'];
                                              //             print("memberMap : $memberMap");
                                              //
                                              //             if(memberMap != null) {
                                              //               // memberList = memberMap.to
                                              //               memberList.addAll(memberMap.values);
                                              //               inviteMemberKeyList.addAll(memberMap.keys);
                                              //             }
                                              //             print("memberList : $memberList");
                                              //             print("inviteMemberKeyList : $inviteMemberKeyList");
                                              //
                                              //             return BookingStatusCard(courtNo: courtId,
                                              //                 cDate: formattedDate,
                                              //                 cTime: slotTime,
                                              //                 inviteMemberList: memberList,
                                              //                 inviteMemberKeyList: inviteMemberKeyList,
                                              //                 bookingId: bookingId,bookingDate: bookedOn,isUpcoming: true,
                                              //               onTap: () => myBookingController.cancelBottomSheet(context: context,bookingId: bookingId, slotTime: slotTime),
                                              //             );
                                              //           },
                                              //         ),
                                              //       )
                                              //       // Padding(
                                              //       //   padding: EdgeInsets.only(top: deviceHeight * 0.01),
                                              //       //   child: BookingStatusCard(courtNo: "Court #1", cDate: "12 Mar 2024", cTime: "10 - 12 pm",inviteMember: "vinay",bookingId: "DFHdhb",bookingDate: "25 Dec 2024"),
                                              //       // )
                                              //           : SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height  * 0.165,
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        decoration: BoxDecoration(
                            color: ConstColor.btnBackGroundColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color:Color(0xffD6D1D3)
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "App Designed by",
                              style: ConstFontStyle().mainTextStyle!.copyWith(color: Color(0xffD6D1D3)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "PATHOS",
                              style: ConstFontStyle().titleText1!.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "DESIGN",
                              style: ConstFontStyle().titleText1!.copyWith(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: deviceHeight * 0.014,
                            ),
                            Text(
                              "www.PathosDesign.in",
                              style: ConstFontStyle()
                                  .mainTextStyle
                                  .copyWith(color: ConstColor.primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height  * 0.165,
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        decoration: BoxDecoration(
                            color: ConstColor.btnBackGroundColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color:Color(0xffD6D1D3)
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "App Developed by",
                              style: ConstFontStyle().mainTextStyle!.copyWith(color: Color(0xffD6D1D3)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "ATTENTION",
                              style: ConstFontStyle().titleText1!.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: deviceHeight * 0.041,
                            ),
                            Text(
                              "www.Attention.sh",
                              style: ConstFontStyle()
                                  .mainTextStyle
                                  .copyWith(color: ConstColor.primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ),
      ),
    );
  }

}


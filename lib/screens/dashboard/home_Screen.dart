import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/comman/constAsset.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/controller/home_controller.dart';
import 'package:m3m_tennis/repository/common_function.dart';
import 'package:m3m_tennis/screens/booking/myBooking%20_screen.dart';
import 'package:m3m_tennis/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bookSlotController = Get.put(BookSlotController());

  final _scrollController = ScrollController();
  final dbref = FirebaseDatabase.instance.ref('Booking');

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    bookSlotController.selectedDate = now;

    for (int i = 0; i < 7; i++) {
      bookSlotController.next7Days.add(now.add(Duration(days: i)));
    }
    print(bookSlotController.next7Days);
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text("Book your next play",style: ConstFontStyle().titleText),
        // titleTextStyle :ConstFontStyle.titleText,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () {
                Get.to(() => MyBookingScreen());
              },
              child: SvgPicture.asset(ConstAsset.bookingIcon,)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
            icon: Icon(Icons.person,color: ConstColor.greyTextColor,),
            // color: ,
          )
        ],
      ),
      body: StreamBuilder(
        stream: dbref.onValue,
        builder: (context, snapshot) {
           if(!snapshot.hasData) {
             return Center(child: CircularProgressIndicator(),);
           } else {
             Map? bookingData = snapshot.data!.snapshot.value as Map?;
             print("bookingData : $bookingData");

             var practiseData = bookingData!['Practise'];
             print("practiseData : $practiseData");

             var userBookingsData = bookingData!['User_Bookings'];
             print("userBookingsData : $userBookingsData");

             return Stack(
               children: [
                 SingleChildScrollView(
                   scrollDirection: Axis.vertical,
                   physics: BouncingScrollPhysics(),
                   child: Container(
                     // height: deviceHeight,
                     // height: deviceHeight * 1.02,

                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 15.0),
                           child: Text( formatDate(bookSlotController.selectedDate!).toString(),style: ConstFontStyle().buttonTextStyle),
                           // child: Text("13 Jan 2024, Saturday",style: ConstFontStyle().buttonTextStyle),
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SingleChildScrollView(
                               physics: NeverScrollableScrollPhysics(),
                               child: Column(
                                 children: [
                                   Container(
                                     height: deviceHeight * 0.067,
                                     width: deviceWidth *0.2,
                                   ),
                                   Container(
                                     height: deviceHeight * 1.9,
                                     width: deviceWidth * 0.2,
                                     child:
                                     ListView.builder(
                                       controller: _scrollController,
                                       itemCount: bookSlotController.timeList.length,
                                       physics: NeverScrollableScrollPhysics(),
                                       itemBuilder: (context, index) {
                                         var value = bookSlotController.timeList[index];
                                         return Padding(
                                           padding: EdgeInsets.only(bottom:deviceHeight * 0.087),
                                           child:  Center(
                                               child: Text(convertTo12HourFormat(value),style: ConstFontStyle().titleText1!.copyWith(fontSize: 12))),
                                         );
                                         //   Container(
                                         //   height: deviceHeight * 0.107,
                                         //   child:Center(
                                         //       child: Text(value.toString() + " AM",style: ConstFontStyle().titleText1!.copyWith(fontSize: 12),)
                                         //   ),
                                         // );
                                         //   ListTile(
                                         //   title: Text(index.toString()),
                                         // );
                                       },
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             SingleChildScrollView(
                               physics: NeverScrollableScrollPhysics(),
                               child: Column(
                                 children: [
                                   Container(
                                     height: deviceHeight * 0.08,
                                     width: deviceWidth * 0.8,
                                     decoration: BoxDecoration(
                                       color: ConstColor.backGroundColor,
                                       border: Border(
                                           bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                         ),
                                     ),
                                     child: Row(
                                       children: [
                                         Expanded(
                                           child: Center(
                                             child: Text(
                                                 'East Court',
                                                 style: ConstFontStyle().titleText1
                                             ),
                                           ),
                                         ),
                                         SizedBox(width: 9),
                                         Container(
                                           width: 1,
                                           color: ConstColor.lineColor,
                                           height: double.infinity,
                                         ),
                                         SizedBox(width: 10),
                                         // Divider(
                                         //   color: Colors.white,
                                         //   height: 10,
                                         //   thickness: 1,
                                         // ),
                                         Expanded(
                                           child: Center(
                                             child: Text(
                                                 'West Court',
                                                 style: ConstFontStyle().titleText1
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Container(
                                     // padding: EdgeInsets.symmetric(vertical: 10),
                                     // height: deviceHeight,
                                     // height: deviceHeight * 0.95,
                                     height: deviceHeight * 1.9,
                                     // height: deviceHeight * 1.08,
                                     // height: deviceHeight * 0.7,
                                     width: deviceWidth * 0.8,
                                     // color: Colors.amber,
                                     child:  GridView.builder(
                                       controller: _scrollController,
                                       scrollDirection: Axis.vertical,
                                       physics: NeverScrollableScrollPhysics(),
                                       // physics: BouncingScrollPhysics(),
                                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                         crossAxisCount: 2,
                                         mainAxisSpacing: 0,
                                         childAspectRatio: 3 / 1.8,
                                         crossAxisSpacing: 0,
                                       ),
                                       cacheExtent: 9999,
                                       itemCount:  bookSlotController.slotList.length * 2,
                                       itemBuilder: (context, index) {
                                         int timeIndex = index ~/ 2;
                                         String slotTime = bookSlotController.slotList[timeIndex];
                                         String halfHourSlotTime = adjustTimeRange(slotTime);
                                         // print("halfHourSlotTime :$index : $halfHourSlotTime");
                                         bool isCompletedOneHourSlot = false;
                                         bool isCompletedHalfHourSlot = false;

                                         DateTime currentTime = DateTime.now();
                                         List<String> dateComponents = bookSlotController.selectedDate!.toString().substring(0, 10).split("-");
                                         int year = int.parse(dateComponents[0]);
                                         int month = int.parse(dateComponents[1]);
                                         int day = int.parse(dateComponents[2]);

                                         List<String> timeParts = slotTime.split(' - ');
                                         List<String> timeParts1 = halfHourSlotTime.split(' - ');

                                         String startTime = timeParts[0];
                                         String endTime = timeParts[1];
                                         String fromTime = convertTo24HourFormat(startTime);
                                         String toTime = convertTo24HourFormat(endTime);
                                         // print("toTime000 : $toTime");
                                         
                                         String startTime1 = timeParts1[0];
                                         String endTime1 = timeParts1[1];
                                         String fromTime1 = convertTo24HourFormat(startTime1);
                                         String toTime1 = convertTo24HourFormat(endTime1);
                                         
                                         
                                         List<String> timeHoursFrom = fromTime.split(':');
                                         List<String> timeHoursTo = toTime.split(':');

                                         DateTime slotFromTime = DateTime(
                                           year,
                                           month,
                                           day,
                                           int.parse(timeHoursFrom[0]),
                                           int.parse(timeHoursFrom[1]),
                                         );
                                         DateTime slotToTime = DateTime(
                                         year,
                                         month,
                                         day,
                                         int.parse(timeHoursTo[0]),
                                         int.parse(timeHoursTo[1]),
                                         );
                                         // print("slotFromTime : $slotFromTime");
                                         // print("slotToTime : $slotToTime");

                                         isCompletedOneHourSlot = currentTime.isAfter(slotToTime);

                                         List<String> timeHoursFrom1 = fromTime1.split(':');
                                         List<String> timeHoursTo1 = toTime1.split(':');
                                         DateTime slotFromTime1 = DateTime(
                                           year,
                                           month,
                                           day,
                                           int.parse(timeHoursFrom1[0]),
                                           int.parse(timeHoursFrom1[1]),
                                         );
                                         DateTime slotToTime1 = DateTime(
                                           year,
                                           month,
                                           day,
                                           int.parse(timeHoursTo1[0]),
                                           int.parse(timeHoursTo1[1]),
                                         );
                                         // print("slotFromTime : $slotFromTime");
                                         // print("slotToTime : $slotToTime");
                                         isCompletedHalfHourSlot = currentTime.isAfter(slotToTime1);

                                         String courtId = index % 2 == 0 ? 'EC'  : 'WC';
                                         bool isPractiseSlot = false;
                                         bool isPractiseSlotOneHour = false;
                                         bool isPractiseSlotHalfHour = false;
                                         bool isPractiseSlotFirstHalf = false;
                                         bool isPractiseSlotSecondHalf = false;

                                         String practiseSlotTime = '';

                                         if(courtId == 'EC') {
                                           if(practiseData['EC']['slotList'].length != 0) {
                                             for(int i=1; i <= practiseData['EC']['slotList'].length; i++) {
                                               // print("i+++" + i.toString());
                                               var slot = practiseData['EC']['slotList']["slot${i.toString()}"];
                                               // print("sloti+++" + slot.toString());
                                               String practiseSlot = slot['from'] +" - "+ slot['to'];
                                               // print("practiseSlot000 : $practiseSlot");
                                               // print("slotTime0000 : $slotTime");
                                               // print("slotTime : $slotTime");

                                               bool match = slotTime == practiseSlot;
                                               // print("match000 : $match");

                                               if(match) {
                                                 isPractiseSlot = true;
                                                 isPractiseSlotOneHour = true;
                                                 practiseSlotTime = practiseSlot;
                                               } else {
                                                 String fromIn24Hours = convertTo24HourFormat(slot['from']);
                                                 String toIn24Hours = convertTo24HourFormat(slot['to']);
                                                 // print("fromIn24Hours : $fromIn24Hours");

                                                 List<String> checkFromTime = fromIn24Hours.split(':');
                                                 List<String> checkFromTime2 = toIn24Hours.split(':');

                                                 DateTime fromTimeInDT = DateTime(
                                                   year,
                                                   month,
                                                   day,
                                                   int.parse(checkFromTime[0]),
                                                   int.parse(checkFromTime[1]),
                                                 );
                                                 DateTime toTimeInDT = DateTime(
                                                   year,
                                                   month,
                                                   day,
                                                   int.parse(checkFromTime2[0]),
                                                   int.parse(checkFromTime2[1]),
                                                 );
                                                 // print("fromTimeInDT $fromTimeInDT");

                                                 bool isFromTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: fromTimeInDT);
                                                 bool istoTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: toTimeInDT);
                                                 // print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                 // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                 if(isFromTimeBetweenInSlot) {
                                                   isPractiseSlot = true;
                                                   isPractiseSlotHalfHour = true;
                                                   isPractiseSlotFirstHalf = true;
                                                   practiseSlotTime = practiseSlot;
                                                 } else if(istoTimeBetweenInSlot) {
                                                   isPractiseSlot = true;
                                                   isPractiseSlotHalfHour = true;
                                                   isPractiseSlotSecondHalf = true;
                                                 }
                                               }
                                             }
                                           }
                                         } else {
                                           // print("length WC : ${practiseData['WC']['slotList'].length}");

                                           if(practiseData['WC']['slotList'].length != 0) {

                                             for(int i=1; i <= practiseData['WC']['slotList'].length; i++) {
                                               // print("i+++" + i.toString());
                                               var slot = practiseData['WC']['slotList']["slot${i.toString()}"];
                                               // print("sloti+++" + slot.toString());

                                               String practiseSlot = slot['from'] +" - "+ slot['to'];
                                               // print("practiseSlot000 : $practiseSlot");
                                               // print("slotTime0000 : $slotTime");
                                               // print("slotTime : $slotTime");

                                               bool match = slotTime == practiseSlot;
                                               // print("match000 : $match");

                                               if(match) {
                                                 isPractiseSlot = true;
                                                 isPractiseSlotOneHour = true;
                                                 practiseSlotTime = practiseSlot;
                                               } else {
                                                 String fromIn24Hours = convertTo24HourFormat(slot['from']);
                                                 String toIn24Hours = convertTo24HourFormat(slot['to']);
                                                 // print("fromIn24Hours : $fromIn24Hours");

                                                 List<String> checkFromTime = fromIn24Hours.split(':');
                                                 List<String> checkFromTime2 = toIn24Hours.split(':');

                                                 DateTime fromTimeInDT = DateTime(
                                                   year,
                                                   month,
                                                   day,
                                                   int.parse(checkFromTime[0]),
                                                   int.parse(checkFromTime[1]),
                                                 );
                                                 DateTime toTimeInDT = DateTime(
                                                   year,
                                                   month,
                                                   day,
                                                   int.parse(checkFromTime2[0]),
                                                   int.parse(checkFromTime2[1]),
                                                 );
                                                 // print("fromTimeInDT $fromTimeInDT");

                                                 bool isFromTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: fromTimeInDT);
                                                 bool istoTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: toTimeInDT);
                                                 // print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                 // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                 if(isFromTimeBetweenInSlot) {
                                                   isPractiseSlot = true;
                                                   isPractiseSlotHalfHour = true;
                                                   isPractiseSlotFirstHalf = true;
                                                   practiseSlotTime = practiseSlot;
                                                 } else if(istoTimeBetweenInSlot) {
                                                   isPractiseSlot = true;
                                                   isPractiseSlotHalfHour = true;
                                                   isPractiseSlotSecondHalf = true;
                                                 }
                                               }
                                             }
                                           }
                                         }

                                         if(isPractiseSlot) {
                                           return Builder(
                                              builder: (context) {
                                                if(isPractiseSlotOneHour) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                        right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child:  Container(
                                                        height: deviceHeight * 0.09,
                                                        width: deviceWidth * 0.33,
                                                        decoration: BoxDecoration(
                                                            color: ConstColor.highLightBooking,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                            practiseSlotTime.toString(),
                                                           style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),
                                                            ),
                                                            Text(
                                                              // time.toString(),
                                                              "Practise Slot",
                                                              style:  ConstFontStyle().titleText1,),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else if(isPractiseSlotHalfHour) {
                                                  if(isPractiseSlotFirstHalf && isPractiseSlotSecondHalf) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                          right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                        ),
                                                      ),
                                                      child: Container(
                                                        height: deviceHeight * 0.09,
                                                        width: deviceWidth * 0.33,
                                                        decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  // print(slotTime);
                                                                  //
                                                                  // print(courtId);
                                                                  // bookSlotController.selectedSlotIndex.value = index;
                                                                  // bookSlotController.selectedSlotTime = slotTime ;
                                                                  // bookSlotController.selectedCourtId = courtId;
                                                                  // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                  // setState(() {
                                                                  // });
                                                                },
                                                                child:  Container(
                                                                    width: deviceWidth * 0.33,
                                                                    margin: EdgeInsets.only(bottom: 5),
                                                                    decoration: BoxDecoration(
                                                                      color: ConstColor.childrenBooking,
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)
                                                                      ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        // time.toString(),
                                                                        "Children",
                                                                        style:  ConstFontStyle().titleText1,),
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              fit: FlexFit.tight,
                                                              child: Container(
                                                                child: fullWidthPath),
                                                            ),
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: GestureDetector(
                                                                onTap: () {

                                                                },
                                                                child: Container(
                                                                  // color: ConstColor.childrenBooking,
                                                                  // height: deviceHeight * 0.09,
                                                                  width: deviceWidth * 0.33,
                                                                  decoration: BoxDecoration(
                                                                    color: ConstColor.childrenBooking,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      practiseSlotTime.toString(),
                                                                      style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else if(isPractiseSlotFirstHalf) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                          right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                        ),
                                                      ),
                                                      child: Container(
                                                        height: deviceHeight * 0.09,
                                                        width: deviceWidth * 0.33,
                                                        decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  // print(slotTime);
                                                                  //
                                                                  // print(courtId);
                                                                  // bookSlotController.selectedSlotIndex.value = index;
                                                                  // bookSlotController.selectedSlotTime = slotTime ;
                                                                  // bookSlotController.selectedCourtId = courtId;
                                                                  // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                  // setState(() {
                                                                  // });
                                                                },
                                                                child: Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              fit: FlexFit.tight,
                                                              child: Container(
                                                                child: fullWidthPath),
                                                            ),
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: Container(
                                                                width: deviceWidth * 0.33,
                                                                decoration: BoxDecoration(
                                                                  color: ConstColor.childrenBooking,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    practiseSlotTime.toString(),
                                                                    style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),
                                                                ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else if(isPractiseSlotSecondHalf) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                          right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                        ),
                                                      ),

                                                      child: Container(
                                                        height: deviceHeight * 0.09,
                                                        width: deviceWidth * 0.33,
                                                        decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: GestureDetector(
                                                                onTap: () {

                                                                },
                                                                child: Container(
                                                                    width: deviceWidth * 0.33,
                                                                    margin: EdgeInsets.only(bottom: 5),
                                                                    decoration: BoxDecoration(
                                                                      color: ConstColor.childrenBooking,
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)
                                                                      ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        // time.toString(),
                                                                        "Children",
                                                                        style:  ConstFontStyle().titleText1,),
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              fit: FlexFit.tight,
                                                              child: Container(
                                                                  child: fullWidthPath
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 10,
                                                              fit: FlexFit.tight,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  // print(slotTime);
                                                                  //
                                                                  // print(courtId);
                                                                  // bookSlotController.selectedSlotIndex.value = index;
                                                                  // bookSlotController.selectedSlotTime = slotTime ;
                                                                  // bookSlotController.selectedCourtId = courtId;
                                                                  // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                  // setState(() {
                                                                  // });
                                                                },
                                                                child: Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                              },
                                           );
                                         } else {
                                           return StreamBuilder(
                                             stream: dbref.child('User_Bookings').orderByChild('date').equalTo(bookSlotController.selectedDate!.toString().substring(0, 10)).onValue,
                                             builder: (context, snapshot) {
                                               if(!snapshot.hasData) {
                                                 return Container();
                                               } else {
                                                 Map? bookData = snapshot.data!.snapshot.value as Map?;
                                                 print("bookingData00001 : $bookingData");

                                                 bool isBookedSlot = false;
                                                 bool bookedSlotIsYour = false;
                                                 bool isBookedSlotOneHour = false;
                                                 bool isBookedSlotHalfHour = false;
                                                 bool isBookedSlotFirstHalf = false;
                                                 bool isBookedSlotSecondHalf = false;

                                                 String bookedTime = '';
                                                 String userId = "";

                                                 // Select Slot
                                                 // bool isSelectedSlot = false;
                                                 // bool isSelectedSlotIsHalfHour = false;
                                                 // bool isSelectedSlotHour = false;

                                                 if(bookData != null) {
                                                   bookData.forEach((key, value) {
                                                     if(value['courtId'] == courtId) {
                                                       String bookedSlotTime = value['from'] +" - "+ value['to'];

                                                       bool match = slotTime == bookedSlotTime;
                                                       // bool matchIsHalfHour = slotTime == bookedSlotTime || slotTime == halfHourSlotTime;
                                                       print("match $match");
                                                       if(match) {
                                                         userId = value['userId'];
                                                         isBookedSlot = true;
                                                         isBookedSlotOneHour = true;
                                                         bookedTime = bookedSlotTime;
                                                         bookedSlotIsYour = bookSlotController.auth.currentUser?.uid == value['userId'];
                                                         // isSelectedSlot = true;
                                                       } else {
                                                         // isSelectedSlot = false;

                                                         String fromIn24Hours = convertTo24HourFormat(value['from']);
                                                         String toIn24Hours = convertTo24HourFormat(value['to']);
                                                         // print("fromIn24Hours : $fromIn24Hours");

                                                         List<String> checkFromTime = fromIn24Hours.split(':');
                                                         List<String> checkFromTime2 = toIn24Hours.split(':');

                                                         DateTime fromTimeInDT = DateTime(
                                                           year,
                                                           month,
                                                           day,
                                                           int.parse(checkFromTime[0]),
                                                           int.parse(checkFromTime[1]),
                                                         );
                                                         DateTime toTimeInDT = DateTime(
                                                           year,
                                                           month,
                                                           day,
                                                           int.parse(checkFromTime2[0]),
                                                           int.parse(checkFromTime2[1]),
                                                         );
                                                         // print("fromTimeInDT $fromTimeInDT");

                                                         bool isFromTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: fromTimeInDT);
                                                         bool istoTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: toTimeInDT);
                                                         print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                         print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                         if(isFromTimeBetweenInSlot) {
                                                           bookedSlotIsYour = bookSlotController.auth.currentUser?.uid == value['userId'];
                                                           userId = value['userId'];
                                                           isBookedSlot = true;
                                                           isBookedSlotHalfHour = true;
                                                           isBookedSlotFirstHalf = true;
                                                           bookedTime = bookedSlotTime;
                                                         } else if(istoTimeBetweenInSlot) {
                                                           bookedSlotIsYour = bookSlotController.auth.currentUser?.uid == value['userId'];
                                                           userId = value['userId'];
                                                           isBookedSlot = true;
                                                           isBookedSlotHalfHour = true;
                                                           isBookedSlotSecondHalf = true;
                                                           // practiseSlotTime = bookedSlotTime;
                                                         }

                                                       }
                                                     }
                                                   });
                                                 }
                                                 // print("isBookedSlot $isBookedSlot");
                                                 // print("isBookedSlotHalfHour $isBookedSlotHalfHour");
                                                 // print("isBookedSlotFirstHalf $isBookedSlotFirstHalf");
                                                 // print("isBookedSlotSecondHalf $isBookedSlotSecondHalf");


                                                 // Select Handel
                                                 bool isSelected = false;
                                                 bool isSelectedSlotOneHour = false;
                                                 bool isSelectedSlotHalfHour = false;
                                                 bool isSelectedSlotFirstHalf = false;
                                                 bool isSelectedSlotSecondHalf = false;

                                                 if(bookSlotController.selectedSlotTime != null) {
                                                   if(bookSlotController.selectedCourtId == courtId) {
                                                     isSelected = slotTime == bookSlotController.selectedSlotTime;
                                                     if(isSelected) {
                                                       isSelectedSlotOneHour = slotTime == bookSlotController.selectedSlotTime;
                                                     } else {
                                                       List<String> times = bookSlotController.selectedSlotTime!.split(" - ");
                                                       String fromTime = times[0];
                                                       String toTime = times[1];

                                                       String fromIn24Hours = convertTo24HourFormat(fromTime);
                                                       String toIn24Hours = convertTo24HourFormat(toTime);
                                                       // print("fromIn24Hours : $fromIn24Hours");

                                                       List<String> checkFromTime = fromIn24Hours.split(':');
                                                       List<String> checkFromTime2 = toIn24Hours.split(':');

                                                       DateTime fromTimeInDT = DateTime(
                                                         year,
                                                         month,
                                                         day,
                                                         int.parse(checkFromTime[0]),
                                                         int.parse(checkFromTime[1]),
                                                       );
                                                       DateTime toTimeInDT = DateTime(
                                                         year,
                                                         month,
                                                         day,
                                                         int.parse(checkFromTime2[0]),
                                                         int.parse(checkFromTime2[1]),
                                                       );
                                                       // print("fromTimeInDT $fromTimeInDT");

                                                       bool isFromTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: fromTimeInDT);
                                                       bool istoTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: toTimeInDT);
                                                       print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                       print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                       if(isFromTimeBetweenInSlot) {
                                                         isSelected = true;
                                                         isSelectedSlotHalfHour = true;
                                                         isSelectedSlotFirstHalf = true;
                                                         // bookedTime = bookedSlotTime;
                                                       } else if(istoTimeBetweenInSlot) {
                                                         isSelected = true;
                                                         isSelectedSlotHalfHour = true;
                                                         isSelectedSlotSecondHalf = true;
                                                       }
                                                     }
                                                   } else {

                                                   }
                                                 }

                                                 return Builder(
                                                   builder: (context) {
                                                     if (isBookedSlot) {
                                                       if(isBookedSlotOneHour) {
                                                         return Container(
                                                           decoration:
                                                           BoxDecoration(
                                                             // color: C,
                                                             border: Border(
                                                               bottom: BorderSide(
                                                                 width: 1.0,
                                                                 color: ConstColor
                                                                     .lineColor,
                                                               ),
                                                               // Top border
                                                               right: BorderSide(
                                                                 width: 1.0,
                                                                 color: ConstColor
                                                                     .lineColor,
                                                               ), // Right border
                                                             ),
                                                           ),
                                                           child: Center(
                                                             child: Container(
                                                               height:
                                                               deviceHeight *
                                                                   0.09,
                                                               width: deviceWidth *
                                                                   0.33,
                                                               padding: EdgeInsets
                                                                   .symmetric(
                                                                   vertical: 2,
                                                                   horizontal:
                                                                   3),
                                                               decoration: BoxDecoration(
                                                                   color: ConstColor
                                                                       .highLightBooking,
                                                                   borderRadius:
                                                                   BorderRadius
                                                                       .circular(
                                                                       5)),
                                                               child: Column(
                                                                 mainAxisAlignment:
                                                                 MainAxisAlignment
                                                                     .center,
                                                                 crossAxisAlignment:
                                                                 CrossAxisAlignment
                                                                     .center,
                                                                 children: [
                                                                   Text(
                                                                       isCompletedOneHourSlot
                                                                           ? "Completed"
                                                                           : slotTime,
                                                                       style: ConstFontStyle()
                                                                           .titleText1!
                                                                           .copyWith(
                                                                         fontSize:
                                                                         12,
                                                                       ),
                                                                       textAlign:
                                                                       TextAlign
                                                                           .center),
                                                                   SizedBox(
                                                                     height: 3,
                                                                   ),
                                                                   StreamBuilder(
                                                                     stream: bookSlotController
                                                                         .dbRefUser
                                                                         .child(userId
                                                                         .toString())
                                                                         .onValue,
                                                                     builder: (context,
                                                                         snapshot) {
                                                                       if (!snapshot
                                                                           .hasData) {
                                                                         return Text(
                                                                           bookedSlotIsYour
                                                                               ? "Your Booking"
                                                                               : "Other",
                                                                           textAlign:
                                                                           TextAlign.center,
                                                                           style: ConstFontStyle()
                                                                               .titleText1,
                                                                         );
                                                                       } else {
                                                                         Map? userDetails = snapshot
                                                                             .data!
                                                                             .snapshot
                                                                             .value as Map?;
                                                                         // print("userName : $userName");
                                                                         String
                                                                         userName =
                                                                         userDetails!['UserName']
                                                                             .toString();
                                                                         // print(
                                                                         //     "userName : $userName");

                                                                         return Text(
                                                                           bookedSlotIsYour
                                                                               ? "Your Booking"
                                                                               : userName,
                                                                           textAlign:
                                                                           TextAlign.center,
                                                                           style: ConstFontStyle()
                                                                               .titleText1,
                                                                         );
                                                                       }
                                                                     },
                                                                   ),
                                                                   // Text(isCompletedOneHourSlot ? "Completed" : "" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,),
                                                                 ],
                                                               ),
                                                             ),
                                                           ),
                                                         );
                                                       } else if(isBookedSlotHalfHour) {
                                                         if(isBookedSlotFirstHalf && isBookedSlotSecondHalf) {
                                                           return Container(
                                                             decoration: BoxDecoration(
                                                               color: Colors.transparent,
                                                               border: Border(
                                                                 bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                 right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                               ),
                                                             ),
                                                             child: Container(
                                                               height: deviceHeight * 0.09,
                                                               width: deviceWidth * 0.33,
                                                               decoration: BoxDecoration(
                                                                 // color: ConstColor.primaryColor,
                                                                   borderRadius: BorderRadius.circular(5)
                                                               ),
                                                               child: Column(
                                                                 mainAxisAlignment:
                                                                 MainAxisAlignment
                                                                     .center,
                                                                 children: [
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {
                                                                         // print(slotTime);
                                                                         //
                                                                         // print(courtId);
                                                                         // bookSlotController.selectedSlotIndex.value = index;
                                                                         // bookSlotController.selectedSlotTime = slotTime ;
                                                                         // bookSlotController.selectedCourtId = courtId;
                                                                         // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                         // setState(() {
                                                                         // });
                                                                       },
                                                                       child:  Container(
                                                                           width: deviceWidth * 0.33,
                                                                           margin: EdgeInsets.only(bottom: 5),
                                                                           decoration: BoxDecoration(
                                                                             color: ConstColor.highLightBooking,
                                                                             borderRadius: BorderRadius.only(
                                                                                 bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)
                                                                             ),
                                                                           ),
                                                                           child: Center(
                                                                             child: StreamBuilder(
                                                                               stream: bookSlotController
                                                                                   .dbRefUser
                                                                                   .child(userId
                                                                                   .toString())
                                                                                   .onValue,
                                                                               builder: (context,
                                                                                   snapshot) {
                                                                                 if (!snapshot
                                                                                     .hasData) {
                                                                                   return Text(
                                                                                     bookedSlotIsYour
                                                                                         ? "Your Booking"
                                                                                         : "Other",
                                                                                     textAlign:
                                                                                     TextAlign.center,
                                                                                     style: ConstFontStyle()
                                                                                         .titleText1,
                                                                                   );
                                                                                 } else {
                                                                                   Map? userDetails = snapshot
                                                                                       .data!
                                                                                       .snapshot
                                                                                       .value as Map?;
                                                                                   // print("userName : $userName");
                                                                                   String
                                                                                   userName =
                                                                                   userDetails!['UserName']
                                                                                       .toString();
                                                                                   print("userName00011 : $userName");
                                                                                   return Text(
                                                                                     bookedSlotIsYour
                                                                                         ? "Your Booking"
                                                                                         : userName,
                                                                                     textAlign:
                                                                                     TextAlign.center,
                                                                                     style: ConstFontStyle()
                                                                                         .titleText1,
                                                                                   );
                                                                                 }
                                                                               },
                                                                             ),

                                                                             // Text(
                                                                             //   // time.toString(),
                                                                             //   "Children",
                                                                             //   style:  ConstFontStyle().titleText1,),
                                                                           )
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 1,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                         child: fullWidthPath),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {

                                                                       },
                                                                       child: Container(
                                                                         // color: ConstColor.childrenBooking,
                                                                         // height: deviceHeight * 0.09,
                                                                         width: deviceWidth * 0.33,
                                                                         decoration: BoxDecoration(
                                                                           color: ConstColor.highLightBooking,
                                                                           borderRadius: BorderRadius.only(
                                                                               topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                           ),
                                                                         ),
                                                                         child: Center(
                                                                           child: Text(
                                                                             bookedTime.toString(),
                                                                             style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           );
                                                         } else if(isBookedSlotFirstHalf) {
                                                           return Container(
                                                             decoration: BoxDecoration(
                                                               color: Colors.transparent,
                                                               border: Border(
                                                                 bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                 right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                               ),
                                                             ),
                                                             child: Container(
                                                               height: deviceHeight * 0.09,
                                                               width: deviceWidth * 0.33,
                                                               decoration: BoxDecoration(
                                                                 // color: ConstColor.primaryColor,
                                                                   borderRadius: BorderRadius.circular(5)
                                                               ),
                                                               child: Column(
                                                                 mainAxisAlignment:
                                                                 MainAxisAlignment
                                                                     .center,
                                                                 children: [
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {

                                                                       },
                                                                       child: Container(
                                                                         color: Colors.transparent,
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 1,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                         child: fullWidthPath),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                       width: deviceWidth * 0.33,
                                                                       decoration: BoxDecoration(
                                                                         color: ConstColor.highLightBooking,
                                                                         borderRadius: BorderRadius.only(
                                                                             topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                         ),
                                                                       ),
                                                                       child: Center(
                                                                         child: Text(
                                                                           bookedTime.toString(),
                                                                           style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           );
                                                         } else if(isBookedSlotFirstHalf && isSelectedSlotSecondHalf) {
                                                           return Container(
                                                             decoration: BoxDecoration(
                                                               color: Colors.transparent,
                                                               border: Border(
                                                                 bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                 right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                               ),
                                                             ),
                                                             child: Container(
                                                               height: deviceHeight * 0.09,
                                                               width: deviceWidth * 0.33,
                                                               decoration: BoxDecoration(
                                                                 // color: ConstColor.primaryColor,
                                                                   borderRadius: BorderRadius.circular(5)
                                                               ),
                                                               child: Column(
                                                                 mainAxisAlignment:
                                                                 MainAxisAlignment
                                                                     .center,
                                                                 children: [
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {

                                                                       },
                                                                       child: Container(
                                                                         color: Colors.transparent,
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 1,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                         child: fullWidthPath),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                       width: deviceWidth * 0.33,
                                                                       decoration: BoxDecoration(
                                                                         color: ConstColor.highLightBooking,
                                                                         borderRadius: BorderRadius.only(
                                                                             topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                         ),
                                                                       ),
                                                                       child: Center(
                                                                         child: Text(
                                                                           bookedTime.toString(),
                                                                           style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           );
                                                         } else if(isBookedSlotSecondHalf) {
                                                           return Container(
                                                             decoration: BoxDecoration(
                                                               color: Colors.transparent,
                                                               border: Border(
                                                                 bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                 right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                               ),
                                                             ),

                                                             child: Container(
                                                               height: deviceHeight * 0.09,
                                                               width: deviceWidth * 0.33,
                                                               decoration: BoxDecoration(
                                                                 // color: ConstColor.primaryColor,
                                                                   borderRadius: BorderRadius.circular(5)
                                                               ),
                                                               child: Column(
                                                                 mainAxisAlignment:
                                                                 MainAxisAlignment
                                                                     .center,
                                                                 children: [
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {
                                                                       },
                                                                       child: Container(
                                                                           width: deviceWidth * 0.33,
                                                                           margin: EdgeInsets.only(bottom: 5),
                                                                           decoration: BoxDecoration(
                                                                             color: ConstColor.highLightBooking,
                                                                             borderRadius: BorderRadius.only(
                                                                                 bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)
                                                                             ),
                                                                           ),
                                                                           child: Center(
                                                                             child: StreamBuilder(
                                                                               stream: bookSlotController
                                                                                   .dbRefUser
                                                                                   .child(userId
                                                                                   .toString())
                                                                                   .onValue,
                                                                               builder: (context,
                                                                                   snapshot) {
                                                                                 if (!snapshot
                                                                                     .hasData) {
                                                                                   return Text(
                                                                                     bookedSlotIsYour
                                                                                         ? "Your Booking"
                                                                                         : "Other",
                                                                                     textAlign:
                                                                                     TextAlign.center,
                                                                                     style: ConstFontStyle()
                                                                                         .titleText1,
                                                                                   );
                                                                                 } else {
                                                                                   Map? userDetails = snapshot
                                                                                       .data!
                                                                                       .snapshot
                                                                                       .value as Map?;
                                                                                   // print("userName : $userName");
                                                                                   String
                                                                                   userName =
                                                                                   userDetails!['UserName']
                                                                                       .toString();
                                                                                   print("userName00011 : $userName");
                                                                                   return Text(
                                                                                     bookedSlotIsYour
                                                                                         ? "Your Booking"
                                                                                         : userName,
                                                                                     textAlign:
                                                                                     TextAlign.center,
                                                                                     style: ConstFontStyle()
                                                                                         .titleText1,
                                                                                   );
                                                                                 }
                                                                               },
                                                                             ),
                                                                             // Text(
                                                                             //   // time.toString(),
                                                                             //   "Children",
                                                                             //   style:  ConstFontStyle().titleText1,),
                                                                           )
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 1,
                                                                     fit: FlexFit.tight,
                                                                     child: Container(
                                                                         child: fullWidthPath
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                     flex: 10,
                                                                     fit: FlexFit.tight,
                                                                     child: GestureDetector(
                                                                       onTap: () {
                                                                         bookSlotController.selectedSlotIndex.value =
                                                                             index;
                                                                         bookSlotController.selectedSlotTime =
                                                                             halfHourSlotTime;
                                                                         bookSlotController.selectedCourtId =
                                                                             courtId;
                                                                         bookSlotController.selectedIsCompleted =
                                                                             isCompletedOneHourSlot;
                                                                         print("halfHourSlotTime : $halfHourSlotTime");
                                                                         setState(() {});
                                                                       },
                                                                       child: Container(
                                                                         color: Colors.transparent,
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           );
                                                         } else {
                                                           return Container();
                                                         }
                                                       } else {
                                                         return Container();
                                                       }
                                                     } else {
                                                       // bool isSelected = false;
                                                       // bool isSelectedSlotOneHour = false;
                                                       // bool isSelectedSlotHalfHour = false;
                                                       // bool isSelectedSlotFirstHalf = false;
                                                       // bool isSelectedSlotSecondHalf = false;
                                                       //
                                                       // // isSelected = bookSlotController
                                                       // //     .selectedSlotIndex
                                                       // //     .value !=
                                                       // //     index;
                                                       //
                                                       // if(bookSlotController.selectedSlotTime != null) {
                                                       //   if(bookSlotController.selectedCourtId == courtId) {
                                                       //     isSelected = slotTime == bookSlotController.selectedSlotTime;
                                                       //     if(isSelected) {
                                                       //       isSelectedSlotOneHour = slotTime == bookSlotController.selectedSlotTime;
                                                       //     } else {
                                                       //       List<String> times = bookSlotController.selectedSlotTime!.split(" - ");
                                                       //       String fromTime = times[0];
                                                       //       String toTime = times[1];
                                                       //
                                                       //       String fromIn24Hours = convertTo24HourFormat(fromTime);
                                                       //       String toIn24Hours = convertTo24HourFormat(toTime);
                                                       //       // print("fromIn24Hours : $fromIn24Hours");
                                                       //
                                                       //       List<String> checkFromTime = fromIn24Hours.split(':');
                                                       //       List<String> checkFromTime2 = toIn24Hours.split(':');
                                                       //
                                                       //       DateTime fromTimeInDT = DateTime(
                                                       //         year,
                                                       //         month,
                                                       //         day,
                                                       //         int.parse(checkFromTime[0]),
                                                       //         int.parse(checkFromTime[1]),
                                                       //       );
                                                       //       DateTime toTimeInDT = DateTime(
                                                       //         year,
                                                       //         month,
                                                       //         day,
                                                       //         int.parse(checkFromTime2[0]),
                                                       //         int.parse(checkFromTime2[1]),
                                                       //       );
                                                       //       // print("fromTimeInDT $fromTimeInDT");
                                                       //
                                                       //       bool isFromTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: fromTimeInDT);
                                                       //       bool istoTimeBetweenInSlot = isBetweenInTimeRange(timeSlot: [slotFromTime,slotToTime],checkTime: toTimeInDT);
                                                       //       print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                       //       print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");
                                                       //
                                                       //       if(isFromTimeBetweenInSlot) {
                                                       //         isSelected = true;
                                                       //         isSelectedSlotHalfHour = true;
                                                       //         isSelectedSlotFirstHalf = true;
                                                       //         // bookedTime = bookedSlotTime;
                                                       //       } else if(istoTimeBetweenInSlot) {
                                                       //         isSelected = true;
                                                       //         isSelectedSlotHalfHour = true;
                                                       //         isSelectedSlotSecondHalf = true;
                                                       //       }
                                                       //     }
                                                       //   } else {
                                                       //
                                                       //   }
                                                       // }
                                                       return Container(
                                                         // height: 120,
                                                         // width: 150,
                                                         // padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                         decoration:
                                                         BoxDecoration(
                                                           // color: Colors.green,
                                                           color: Colors
                                                               .transparent,
                                                           border: Border(
                                                             bottom:
                                                             BorderSide(
                                                               width: 1.0,
                                                               color: ConstColor
                                                                   .lineColor,
                                                             ),
                                                             // Top border
                                                             right: BorderSide(
                                                               width: 1.0,
                                                               color: ConstColor
                                                                   .lineColor,
                                                             ), // Right border
                                                           ),
                                                         ),
                                                         child: Builder(
                                                           builder: (context) {
                                                             if(isSelected) {
                                                               if(isSelectedSlotOneHour) {
                                                                 return Center(
                                                                   child:
                                                                   Container(
                                                                     height:
                                                                     deviceHeight *
                                                                         0.09,
                                                                     width:
                                                                     deviceWidth *
                                                                         0.33,
                                                                     padding: EdgeInsets.symmetric(
                                                                         vertical:
                                                                         2,
                                                                         horizontal:
                                                                         3),
                                                                     decoration: BoxDecoration(
                                                                         color: isCompletedOneHourSlot
                                                                             ? ConstColor
                                                                             .greyTextColor
                                                                             : ConstColor
                                                                             .primaryColor,
                                                                         borderRadius:
                                                                         BorderRadius.circular(5)),
                                                                     child:
                                                                     Column(
                                                                       mainAxisAlignment:
                                                                       MainAxisAlignment
                                                                           .center,
                                                                       crossAxisAlignment:
                                                                       CrossAxisAlignment
                                                                           .center,
                                                                       children: [
                                                                         Text(
                                                                             slotTime,
                                                                             style:
                                                                             ConstFontStyle().titleText1,
                                                                             textAlign: TextAlign.center),
                                                                       ],
                                                                     ),
                                                                   ),
                                                                 );
                                                               } else if(isSelectedSlotHalfHour) {
                                                                 if(isSelectedSlotFirstHalf) {
                                                                   return Container(
                                                                     decoration: BoxDecoration(
                                                                       color: Colors.transparent,
                                                                       // border: Border(
                                                                       //   bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                       //   right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                                       // ),
                                                                     ),
                                                                     child: Container(
                                                                       height: deviceHeight * 0.09,
                                                                       width: deviceWidth * 0.33,
                                                                       decoration: BoxDecoration(
                                                                         // color: ConstColor.primaryColor,
                                                                           borderRadius: BorderRadius.circular(5)
                                                                       ),
                                                                       child: Column(
                                                                         mainAxisAlignment:
                                                                         MainAxisAlignment
                                                                             .center,
                                                                         children: [
                                                                           Flexible(
                                                                             flex: 10,
                                                                             fit: FlexFit.tight,
                                                                             child: GestureDetector(
                                                                               onTap: () {

                                                                               },
                                                                               child: Container(
                                                                                 color: Colors.transparent,
                                                                               ),
                                                                             ),
                                                                           ),
                                                                           Flexible(
                                                                             flex: 1,
                                                                             fit: FlexFit.tight,
                                                                             child: Container(
                                                                                 child: fullWidthPath),
                                                                           ),
                                                                           Flexible(
                                                                             flex: 10,
                                                                             fit: FlexFit.tight,
                                                                             child: Container(
                                                                               width: deviceWidth * 0.33,
                                                                               decoration: BoxDecoration(
                                                                                 color: isCompletedHalfHourSlot
                                                                                     ? ConstColor
                                                                                     .greyTextColor
                                                                                     : ConstColor
                                                                                     .primaryColor,
                                                                                 borderRadius: BorderRadius.only(
                                                                                     topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                                 ),
                                                                               ),
                                                                               child: Center(
                                                                                 child: Text(
                                                                                   bookSlotController.selectedSlotTime.toString(),
                                                                                   style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12),
                                                                                 ),
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         ],
                                                                       ),
                                                                     ),
                                                                   );
                                                                 } else if(isSelectedSlotSecondHalf) {
                                                                   return Container(
                                                                     decoration: BoxDecoration(
                                                                       color: Colors.transparent,
                                                                       // border: Border(
                                                                       //   bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                       //   right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                                       // ),
                                                                     ),

                                                                     child: Container(
                                                                       height: deviceHeight * 0.09,
                                                                       width: deviceWidth * 0.33,
                                                                       decoration: BoxDecoration(
                                                                         // color: ConstColor.primaryColor,
                                                                           borderRadius: BorderRadius.circular(5)
                                                                       ),
                                                                       child: Column(
                                                                         mainAxisAlignment:
                                                                         MainAxisAlignment
                                                                             .center,
                                                                         children: [
                                                                           Flexible(
                                                                             flex: 10,
                                                                             fit: FlexFit.tight,
                                                                             child: GestureDetector(
                                                                               onTap: () {

                                                                               },
                                                                               child: Container(
                                                                                   width: deviceWidth * 0.33,
                                                                                   margin: EdgeInsets.only(bottom: 5),
                                                                                   decoration: BoxDecoration(
                                                                                     color: isCompletedHalfHourSlot
                                                                                         ? ConstColor
                                                                                         .greyTextColor
                                                                                         : ConstColor
                                                                                         .primaryColor,
                                                                                     borderRadius: BorderRadius.only(
                                                                                         bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)
                                                                                     ),
                                                                                   ),
                                                                                   child: Center(
                                                                                     child: Text(
                                                                                       isCompletedHalfHourSlot
                                                                                           ? "Completed" : "Available",
                                                                                       // bookSlotController.selectedSlotTime.toString(),
                                                                                       style:  ConstFontStyle().titleText1!.copyWith(fontSize: 14),
                                                                                     ),
                                                                                   )
                                                                               ),
                                                                             ),
                                                                           ),
                                                                           Flexible(
                                                                             flex: 1,
                                                                             fit: FlexFit.tight,
                                                                             child: Container(
                                                                                 child: fullWidthPath
                                                                             ),
                                                                           ),
                                                                           Flexible(
                                                                             flex: 10,
                                                                             fit: FlexFit.tight,
                                                                             child: GestureDetector(
                                                                               onTap: () {
                                                                                 // print(slotTime);
                                                                                 //
                                                                                 // print(courtId);
                                                                                 // bookSlotController.selectedSlotIndex.value = index;
                                                                                 // bookSlotController.selectedSlotTime = slotTime ;
                                                                                 // bookSlotController.selectedCourtId = courtId;
                                                                                 // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                                 // setState(() {
                                                                                 // });
                                                                               },
                                                                               child: Container(
                                                                                 color: Colors.transparent,
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         ],
                                                                       ),
                                                                     ),
                                                                   );
                                                                 } else {
                                                                   return Container();
                                                                 }
                                                               }  else {
                                                                 return Container();
                                                               }
                                                             } else {
                                                               return
                                                                 // Container();
                                                                 Container(
                                                                 height:
                                                                 deviceHeight *
                                                                     0.09,
                                                                 width:
                                                                 deviceWidth *
                                                                     0.33,
                                                                 decoration:
                                                                 BoxDecoration(
                                                                   // color: ConstColor.highLightBooking,
                                                                     borderRadius:
                                                                     BorderRadius.circular(5)),
                                                                 child: Column(
                                                                   mainAxisAlignment:
                                                                   MainAxisAlignment
                                                                       .center,
                                                                   children: [
                                                                     Flexible(
                                                                       flex:
                                                                       10,
                                                                       fit: FlexFit
                                                                           .tight,
                                                                       child:
                                                                       GestureDetector(
                                                                         onTap:
                                                                             () {
                                                                           print(slotTime);

                                                                           print(courtId);
                                                                           bookSlotController.selectedSlotIndex.value =
                                                                               index;
                                                                           bookSlotController.selectedSlotTime =
                                                                               slotTime;
                                                                           bookSlotController.selectedCourtId =
                                                                               courtId;
                                                                           bookSlotController.selectedIsCompleted =
                                                                               isCompletedOneHourSlot;
                                                                           setState(() {});
                                                                         },
                                                                         child:
                                                                         Container(
                                                                           color:
                                                                           Colors.transparent,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                     Flexible(
                                                                       flex: 1,
                                                                       fit: FlexFit
                                                                           .tight,
                                                                       child: Container(
                                                                           child:
                                                                           fullWidthPath),
                                                                     ),
                                                                     Flexible(
                                                                       flex:
                                                                       10,
                                                                       fit: FlexFit
                                                                           .tight,
                                                                       child:
                                                                       GestureDetector(
                                                                         onTap:
                                                                             () {
                                                                           // print(courtId);
                                                                           bookSlotController.selectedSlotIndex.value =
                                                                               index;
                                                                           bookSlotController.selectedSlotTime =
                                                                               halfHourSlotTime;
                                                                           bookSlotController.selectedCourtId =
                                                                               courtId;
                                                                           bookSlotController.selectedIsCompleted =
                                                                               isCompletedOneHourSlot;
                                                                           print("halfHourSlotTime : $halfHourSlotTime");
                                                                           setState(() {});
                                                                         },
                                                                         child:
                                                                         Container(
                                                                           color:
                                                                           Colors.transparent,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ],
                                                                 ),
                                                               );
                                                             }
                                                           },
                                                         ),
                                                       );
                                                     }
                                                   },
                                                 );
                                              }
                                             },
                                           );
                                         }

                                       },
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
                 Positioned(
                   bottom: deviceHeight * 0.02, // Adjust top position as needed
                   right: deviceWidth * 0.3, // Adjust right position as needed
                   child: ElevatedButton(
                     onPressed: () async {
                      // bookSlotController.confirmBookingSlot(context);

                       if(await bookSlotController.checkUserNameExist()) {
                         Utils().snackBar(message: "Please add your name first.");
                         Get.to(() => ProfileScreen());
                       }  else {
                         if(bookSlotController.selectedSlotTime == null) {
                           Utils().snackBar(message: "Please select slot for booking.");
                         } else if(bookSlotController.selectedIsCompleted) {
                           Utils().snackBar(message: "Slot is completed. Please choose available slot.");
                         }  else {
                           bookSlotController.checkUserAbelToBook(context: context);
                         }
                       }

                       // int courtId = bookSlotController.selectedCourtId == 'WC' ? 2 : 1;
                       //
                       // DateTime dateTime =
                       // DateTime.parse(bookSlotController.selectedDate!.toString().substring(0, 10));
                       // String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
                       //
                       // bookSlotController.confirmationBottomSheet(
                       //     context: context,
                       //     courtId: courtId,
                       //     slot: bookSlotController.selectedSlotTime!,
                       //     date: formattedDate);
                     },
                     style: ElevatedButton.styleFrom(
                       shape: CircleBorder(),
                       padding: EdgeInsets.all(20),
                       backgroundColor: ConstColor.primaryColor
                     ),
                     child: Text('Book',style: ConstFontStyle().textStyle1,)
                     // Icon(Icons.add, size: 30),
                   ),
                 ),
               ],
             );
           }
        },
      ),
      bottomNavigationBar: Container(
        height: deviceHeight * 0.12,
        width: deviceWidth,
        color: ConstColor.btnBackGroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.arrow_back_ios_new,size: 20,)
              ),
              Container(
                width: deviceWidth * 0.72,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(bookSlotController.next7Days.length,
                            (index) {
                          var item = bookSlotController.next7Days[index];
                          // print("index : ${bookSlotController.next7Days[index]}");

                          int date = int.parse(item.day.toString());
                          String dateText = index == 0
                              ? "Today"
                              : index == 1
                              ? "Tmrw"
                              : date.toString().padLeft(2, '0');
                          String dayName =
                          DateFormat('EEEE').format(item).substring(0, 3);

                          return StreamBuilder(
                            stream: dbref.child('User_Bookings').orderByChild('date').equalTo(item.toString().substring(0, 10)).onValue,
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) {
                                return SizedBox();
                              } else {
                                Map? bookingData = snapshot.data!.snapshot.value as Map?;
                                // print("bookingData00001 : $bookingData");

                                int availableSlot = 30;
                                if(bookingData != null) {
                                  availableSlot = 30 - bookingData!.length;
                                }
                                // print('Number of availableSlot : $availableSlot');

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      bookSlotController.selectedDateIndex = index;
                                      bookSlotController.selectedDate = item;
                                      bookSlotController.selectedSlotTime = null;
                                      bookSlotController.selectedSlotIndex.value = -1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: deviceHeight * .09,
                                      width: deviceWidth * 0.2,
                                      color: bookSlotController.selectedDateIndex == index
                                          ? ConstColor.greyTextColor!.withOpacity(0.1)
                                          : Colors.transparent,
                                      child: Column(
                                        children: [
                                          Text(dateText,
                                              style: index ==
                                                  bookSlotController.selectedDateIndex
                                                  ? ConstFontStyle().headline2
                                                  : ConstFontStyle().titleText1),
                                          Text(dayName,
                                              style: ConstFontStyle().mainTextStyle3),
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text("$availableSlot slots",
                                                style: index ==
                                                    bookSlotController
                                                        .selectedDateIndex
                                                    ? ConstFontStyle().headline1
                                                    : ConstFontStyle()
                                                    .titleText1!
                                                    .copyWith(
                                                  fontSize: 12,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.arrow_forward_ios_sharp,size: 20,)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get fullWidthPath {
    return DottedBorder(
      customPath: (size) {
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0);
      },
      dashPattern: [5, 5],
        color:ConstColor.backBtnColor,
      child: Container(),
    );
  }
}

// import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
// import 'package:m3m_tennis/comman/constColor.dart';
// import 'package:m3m_tennis/comman/constFontStyle.dart';
// import 'package:m3m_tennis/comman/snackbar.dart';
// import 'package:m3m_tennis/controller/home_controller.dart';
// import 'package:m3m_tennis/repository/common_function.dart';
// import 'package:m3m_tennis/screens/booking/myBooking%20_screen.dart';
// import 'package:m3m_tennis/screens/profile/profile_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final bookSlotController = Get.put(BookSlotController());
//
//   final _scrollController = ScrollController();
//   final dbref = FirebaseDatabase.instance.ref('Booking');
//
//   @override
//   void initState() {
//     super.initState();
//
//     DateTime now = DateTime.now();
//     bookSlotController.selectedDate = now;
//
//     for (int i = 0; i < 7; i++) {
//       bookSlotController.next7Days.add(now.add(Duration(days: i)));
//     }
//     print(bookSlotController.next7Days);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var deviceHeight = MediaQuery.of(context).size.height;
//     var deviceWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: ConstColor.backGroundColor,
//       appBar: AppBar(
//         backgroundColor: ConstColor.backGroundColor,
//         title: Text("Book your next play",style: ConstFontStyle().titleText),
//         // titleTextStyle :ConstFontStyle.titleText,
//         centerTitle: true,
//         leading: GestureDetector(
//             onTap: () {
//               Get.to(() => MyBookingScreen());
//             },
//             child: Icon(Icons.event_note_sharp,color: ConstColor.greyTextColor,)),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.to(() => ProfileScreen());
//             },
//             icon: Icon(Icons.person,color: ConstColor.greyTextColor,),
//             // color: ,
//           )
//         ],
//       ),
//       body: StreamBuilder(
//         stream: dbref.onValue,
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator(),);
//           } else {
//             Map? bookingData = snapshot.data!.snapshot.value as Map?;
//             print("bookingData : $bookingData");
//
//             var practiseData = bookingData!['Practise'];
//             print("practiseData : $practiseData");
//
//             var userBookingsData = bookingData!['User_Bookings'];
//             print("userBookingsData : $userBookingsData");
//
//             return Stack(
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   physics: BouncingScrollPhysics(),
//                   child: Container(
//                     // height: deviceHeight,
//                     // height: deviceHeight * 1.02,
//
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15.0),
//                           child: Text( formatDate(bookSlotController.selectedDate!).toString(),style: ConstFontStyle().buttonTextStyle),
//                           // child: Text("13 Jan 2024, Saturday",style: ConstFontStyle().buttonTextStyle),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SingleChildScrollView(
//                               physics: NeverScrollableScrollPhysics(),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: deviceHeight * 0.067,
//                                     width: deviceWidth *0.2,
//                                   ),
//                                   Container(
//                                     height: deviceHeight * 1.9,
//                                     width: deviceWidth * 0.2,
//                                     child:
//                                     ListView.builder(
//                                       controller: _scrollController,
//                                       itemCount: bookSlotController.timeList.length,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         var value = bookSlotController.timeList[index];
//                                         return Padding(
//                                           padding: EdgeInsets.only(bottom:deviceHeight * 0.087),
//                                           child:  Center(
//                                               child: Text(convertTo12HourFormat(value),style: ConstFontStyle().titleText1!.copyWith(fontSize: 12))),
//                                         );
//                                         //   Container(
//                                         //   height: deviceHeight * 0.107,
//                                         //   child:Center(
//                                         //       child: Text(value.toString() + " AM",style: ConstFontStyle().titleText1!.copyWith(fontSize: 12),)
//                                         //   ),
//                                         // );
//                                         //   ListTile(
//                                         //   title: Text(index.toString()),
//                                         // );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SingleChildScrollView(
//                               physics: NeverScrollableScrollPhysics(),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: deviceHeight * 0.08,
//                                     width: deviceWidth * 0.8,
//                                     decoration: BoxDecoration(
//                                       color: ConstColor.backGroundColor,
//                                       border: Border(
//                                         bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
//                                       ),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           child: Center(
//                                             child: Text(
//                                                 'East Court',
//                                                 style: ConstFontStyle().titleText1
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 9),
//                                         Container(
//                                           width: 1,
//                                           color: ConstColor.lineColor,
//                                           height: double.infinity,
//                                         ),
//                                         SizedBox(width: 10),
//                                         // Divider(
//                                         //   color: Colors.white,
//                                         //   height: 10,
//                                         //   thickness: 1,
//                                         // ),
//                                         Expanded(
//                                           child: Center(
//                                             child: Text(
//                                                 'West Court',
//                                                 style: ConstFontStyle().titleText1
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     // padding: EdgeInsets.symmetric(vertical: 10),
//                                     // height: deviceHeight,
//                                     // height: deviceHeight * 0.95,
//                                     height: deviceHeight * 1.9,
//                                     // height: deviceHeight * 1.08,
//                                     // height: deviceHeight * 0.7,
//                                     width: deviceWidth * 0.8,
//                                     // color: Colors.amber,
//                                     child:  GridView.builder(
//                                       controller: _scrollController,
//                                       scrollDirection: Axis.vertical,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       // physics: BouncingScrollPhysics(),
//                                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         mainAxisSpacing: 0,
//                                         childAspectRatio: 3 / 1.8,
//                                         crossAxisSpacing: 0,
//                                       ),
//                                       cacheExtent: 9999,
//                                       itemCount:  bookSlotController.slotList.length * 2,
//                                       itemBuilder: (context, index) {
//                                         int timeIndex = index ~/ 2;
//                                         String slotTime = bookSlotController.slotList[timeIndex];
//                                         bool isCompletedOneHourSlot = false;
//
//                                         DateTime currentTime = DateTime.now();
//                                         List<String> dateComponents = bookSlotController.selectedDate!.toString().substring(0, 10).split("-");
//                                         int year = int.parse(dateComponents[0]);
//                                         int month = int.parse(dateComponents[1]);
//                                         int day = int.parse(dateComponents[2]);
//
//                                         List<String> timeParts = slotTime.split(' - ');
//                                         String endTime = timeParts[1];
//                                         String toTime = convertTo24HourFormat(endTime);
//                                         print("toTime000 : $toTime");
//
//                                         List<String> timeHoursTo = toTime.split(':');
//                                         DateTime slotToTime = DateTime(
//                                           year,
//                                           month,
//                                           day,
//                                           int.parse(timeHoursTo[0]),
//                                           int.parse(timeHoursTo[1]),
//                                         );
//                                         isCompletedOneHourSlot = currentTime.isAfter(slotToTime);
//
//
//                                         String courtId = index % 2 == 0 ? 'EC'  : 'WC';
//                                         bool isPractiseSlot = false;
//
//                                         if(courtId == 'EC') {
//                                           // print("length : ${practiseData['EC']['slotList'].length}");
//                                           if(practiseData['EC']['slotList'].length != 0) {
//
//                                             for(int i=1; i <= practiseData['EC']['slotList'].length; i++) {
//                                               // print("i+++" + i.toString());
//                                               var slot = practiseData['EC']['slotList']["slot${i.toString()}"];
//                                               // print("sloti+++" + slot.toString());
//
//                                               String practiseSlotTime = slot['from'] +" - "+ slot['to'];
//                                               // print("practiseSlotTime : $practiseSlotTime");
//                                               // print("slotTime : $slotTime");
//
//                                               bool match = slotTime == practiseSlotTime;
//                                               if(match) {
//                                                 isPractiseSlot = true;
//                                               }
//                                               // print("isisPractiseSlot : $isPractiseSlot");
//                                             }
//                                           }
//                                         } else {
//                                           if(practiseData['WC']['slotList'].length != 0) {
//                                             for(int i=1; i <= practiseData['WC']['slotList'].length; i++) {
//                                               var slot = practiseData['WC']['slotList']["slot${i.toString()}"];
//                                               String practiseSlotTime = slot['from'] +" - "+ slot['to'];
//                                               bool match = slotTime == practiseSlotTime;
//                                               if(match) {
//                                                 isPractiseSlot = true;
//                                               }
//                                             }
//                                           }
//                                         }
//
//                                         if(isPractiseSlot) {
//                                           return Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.transparent,
//                                               border: Border(
//                                                 bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
//                                                 right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child:  Container(
//                                                 height: deviceHeight * 0.09,
//                                                 width: deviceWidth * 0.33,
//                                                 decoration: BoxDecoration(
//                                                     color: ConstColor.childrenBooking,
//                                                     borderRadius: BorderRadius.circular(5)
//                                                 ),
//                                                 child: Center(child: Text(
//                                                   // time.toString(),
//                                                   "Children",
//                                                   style:  ConstFontStyle().titleText1,)),
//                                               ),
//                                             ),
//                                           );
//                                         } else {
//
//                                           return StreamBuilder(
//                                             stream: dbref.child('User_Bookings').orderByChild('date').equalTo(bookSlotController.selectedDate!.toString().substring(0, 10)).onValue,
//                                             builder: (context, snapshot) {
//                                               if(!snapshot.hasData) {
//                                                 return Container();
//                                               } else {
//                                                 Map? bookData = snapshot.data!.snapshot.value as Map?;
//                                                 print("bookingData00001 : $bookingData");
//
//                                                 // Map? bookData = userBookingsData;
//                                                 // print("bookData : $bookData");
//                                                 bool isBookedSlot = false;
//                                                 bool bookedSlotIsYour = false;
//                                                 String userId = "";
//
//                                                 if(bookData != null) {
//                                                   bookData.forEach((key, value) {
//                                                     // print("key : $key");
//                                                     // print("value : $value");
//
//                                                     // DateTime currentTime = DateTime.now();
//                                                     // print("currentTime0000 : $currentTime");
//                                                     //
//                                                     // List<String> dateComponents = value['date'].split("-");
//                                                     // int year = int.parse(dateComponents[0]);
//                                                     // int month = int.parse(dateComponents[1]);
//                                                     // int day = int.parse(dateComponents[2]);
//                                                     // String toTime = convertTo24HourFormat(value['to']);
//                                                     // print("toTime000 : $toTime");
//                                                     //
//                                                     // List<String> timeParts = toTime.split(':');
//                                                     // DateTime slotToTime = DateTime(
//                                                     //   year,
//                                                     //   month,
//                                                     //   day,
//                                                     //   int.parse(timeParts[0]),
//                                                     //   int.parse(timeParts[1]),
//                                                     // );
//                                                     // isCompletedOneHourSlot = currentTime.isAfter(slotToTime);
//                                                     // print("isCompletedOneHourSlot000 : $isCompletedOneHourSlot");
//                                                     // if() {
//                                                     //
//                                                     // }
//
//                                                     if(value['courtId'] == courtId) {
//                                                       //
//                                                       String bookedSlotTime = value['from'] +" - "+ value['to'];
//                                                       // print("slotTime $slotTime");
//                                                       // print("bookedSlotTime $bookedSlotTime");
//
//                                                       bool match = slotTime == bookedSlotTime;
//                                                       print("match $match");
//                                                       if(match) {
//                                                         userId = value['userId'];
//                                                         isBookedSlot = true;
//                                                         bookedSlotIsYour = bookSlotController.auth.currentUser?.uid == value['userId'];
//                                                       }
//                                                     }
//                                                   });
//                                                   print("isBookedSlot $isBookedSlot");
//                                                 }
//
//                                                 return isBookedSlot ?
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                     // color: C,
//                                                     border: Border(
//                                                       bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
//                                                       right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
//                                                     ),
//                                                   ),
//                                                   child: Center(
//                                                     child:  Container(
//                                                       height: deviceHeight * 0.09,
//                                                       width: deviceWidth * 0.33,
//                                                       padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
//                                                       decoration: BoxDecoration(
//                                                           color: ConstColor.highLightBooking,
//                                                           borderRadius: BorderRadius.circular(5)
//                                                       ),
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         children: [
//                                                           Text(isCompletedOneHourSlot ? "Completed" : slotTime, style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),textAlign:  TextAlign.center),
//                                                           SizedBox(height: 3,),
//                                                           StreamBuilder(
//                                                             stream: bookSlotController.dbRefUser.child(userId.toString()).onValue,
//                                                             builder: (context, snapshot) {
//                                                               if(!snapshot.hasData) {
//                                                                 return Text(bookedSlotIsYour ? "Your Booking" : "Other" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,);
//                                                               } else {
//                                                                 Map? userDetails = snapshot.data!.snapshot.value as Map?;
//                                                                 // print("userName : $userName");
//                                                                 String userName = userDetails!['UserName'].toString();
//                                                                 print("userName : $userName");
//
//                                                                 return Text(bookedSlotIsYour ? "Your Booking" : userName ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,);
//                                                               }
//                                                             },
//                                                           ),
//                                                           // Text(isCompletedOneHourSlot ? "Completed" : "" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                                     :
//                                                 GestureDetector(
//                                                   onTap: () {
//
//                                                   },
//                                                   child: Container(
//                                                     // height: 120,
//                                                     // width: 150,
//                                                     // padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
//                                                     decoration: BoxDecoration(
//                                                       // color: Colors.green,
//                                                       color: Colors.transparent,
//                                                       border: Border(
//                                                         bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
//                                                         right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
//                                                       ),
//                                                     ),
//                                                     child: bookSlotController.selectedSlotIndex.value != index ?
//                                                     // SizedBox()
//                                                     // Center(
//                                                     //   child: Container(
//                                                     //     width: double.maxFinite,
//                                                     //     child: DottedBorder(
//                                                     //       color: Colors.white, // Change the color as per your requirement
//                                                     //       strokeWidth: 1.0, // Change the width as per your requirement
//                                                     //       borderType: BorderType.RRect,
//                                                     //       radius: Radius.circular(0),
//                                                     //       dashPattern: [5, 5], // Change the dash pattern as per your requirement
//                                                     //       child: Container(),
//                                                     //     ),
//                                                     //   ),
//                                                     // )
//                                                     Container(
//                                                       height: deviceHeight * 0.09,
//                                                       width: deviceWidth * 0.33,
//                                                       // padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
//                                                       decoration: BoxDecoration(
//                                                         // color: ConstColor.highLightBooking,
//                                                           borderRadius: BorderRadius.circular(5)
//                                                       ),
//                                                       child: Column(
//                                                         // mainAxisSize: MainAxisSize.max,
//                                                         mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           Flexible(
//                                                             flex: 10,
//                                                             fit: FlexFit.tight,
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                 print(slotTime);
//                                                                 print(courtId);
//                                                                 bookSlotController.selectedSlotIndex.value = index;
//                                                                 bookSlotController.selectedSlotTime = slotTime ;
//                                                                 bookSlotController.selectedCourtId = courtId;
//                                                                 bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
//                                                                 setState(() {
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 // color: Colors.amber,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Flexible(
//                                                             flex: 1,
//                                                             fit: FlexFit.tight,                                                                        child: Container(
//                                                               child: fullWidthPath),
//                                                           ),
//                                                           GestureDetector(
//                                                             onTap: () {
//
//                                                             },
//                                                             child: Flexible(
//                                                               flex: 10,
//                                                               fit: FlexFit.tight,                                                                        child: Container(
//                                                               // color: Colors.red,
//                                                             ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                         : Center(
//                                                       child:  Container(
//                                                         height: deviceHeight * 0.09,
//                                                         width: deviceWidth * 0.33,
//                                                         padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
//                                                         decoration: BoxDecoration(
//                                                             color: isCompletedOneHourSlot ? ConstColor.greyTextColor : ConstColor.primaryColor,
//                                                             borderRadius: BorderRadius.circular(5)
//                                                         ),
//                                                         child: Column(
//                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                           crossAxisAlignment: CrossAxisAlignment.center,
//                                                           children: [
//                                                             Text(slotTime,style:  ConstFontStyle().titleText1,textAlign:  TextAlign.center),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                             },
//                                           );
//                                         }
//
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: deviceHeight * 0.02, // Adjust top position as needed
//                   right: deviceWidth * 0.3, // Adjust right position as needed
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         // bookSlotController.confirmBookingSlot(context);
//
//                         if(await bookSlotController.checkUserNameExist()) {
//                           Utils().snackBar(message: "Please add your name first.");
//                           Get.to(() => ProfileScreen());
//                         }  else {
//                           if(bookSlotController.selectedSlotTime == null) {
//                             Utils().snackBar(message: "Please select slot for booking.");
//                           } else if(bookSlotController.selectedisCompletedOneHourSlot) {
//                             Utils().snackBar(message: "Slot is completed. Please choose available slot.");
//                           }  else {
//                             bookSlotController.checkUserAbelToBook(context: context);
//                           }
//                         }
//
//                         // int courtId = bookSlotController.selectedCourtId == 'WC' ? 2 : 1;
//                         //
//                         // DateTime dateTime =
//                         // DateTime.parse(bookSlotController.selectedDate!.toString().substring(0, 10));
//                         // String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
//                         //
//                         // bookSlotController.confirmationBottomSheet(
//                         //     context: context,
//                         //     courtId: courtId,
//                         //     slot: bookSlotController.selectedSlotTime!,
//                         //     date: formattedDate);
//                       },
//                       style: ElevatedButton.styleFrom(
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(20),
//                           backgroundColor: ConstColor.primaryColor
//                       ),
//                       child: Text('Book',style: ConstFontStyle().textStyle1,)
//                     // Icon(Icons.add, size: 30),
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: Container(
//         height: deviceHeight * 0.12,
//         width: deviceWidth,
//         color: ConstColor.btnBackGroundColor,
//         child: Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               IconButton(
//                   onPressed: () {
//
//                   },
//                   icon: Icon(Icons.arrow_back_ios_new,size: 20,)
//               ),
//               Container(
//                 width: deviceWidth * 0.72,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(bookSlotController.next7Days.length,
//                             (index) {
//                           var item = bookSlotController.next7Days[index];
//                           print("index : ${bookSlotController.next7Days[index]}");
//
//                           int date = int.parse(item.day.toString());
//                           String dateText = index == 0
//                               ? "Today"
//                               : index == 1
//                               ? "Tmrw"
//                               : date.toString().padLeft(2, '0');
//                           String dayName =
//                           DateFormat('EEEE').format(item).substring(0, 3);
//
//                           return StreamBuilder(
//                             stream: dbref.child('User_Bookings').orderByChild('date').equalTo(item.toString().substring(0, 10)).onValue,
//                             builder: (context, snapshot) {
//                               if(!snapshot.hasData) {
//                                 return SizedBox();
//                               } else {
//                                 Map? bookingData = snapshot.data!.snapshot.value as Map?;
//                                 print("bookingData00001 : $bookingData");
//
//                                 int availableSlot = 30;
//                                 if(bookingData != null) {
//                                   availableSlot = 30 - bookingData!.length;
//                                 }
//                                 print('Number of availableSlot : $availableSlot');
//
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       bookSlotController.selectedDateIndex = index;
//                                       bookSlotController.selectedDate = item;
//                                       bookSlotController.selectedSlotTime = null;
//                                       bookSlotController.selectedSlotIndex.value = -1;
//                                       setState(() {});
//                                     },
//                                     child: Container(
//                                       height: deviceHeight * .09,
//                                       width: deviceWidth * 0.2,
//                                       color: bookSlotController.selectedDateIndex == index
//                                           ? ConstColor.greyTextColor!.withOpacity(0.1)
//                                           : Colors.transparent,
//                                       child: Column(
//                                         children: [
//                                           Text(dateText,
//                                               style: index ==
//                                                   bookSlotController.selectedDateIndex
//                                                   ? ConstFontStyle().headline2
//                                                   : ConstFontStyle().titleText1),
//                                           Text(dayName,
//                                               style: ConstFontStyle().mainTextStyle3),
//                                           Padding(
//                                             padding:
//                                             const EdgeInsets.symmetric(vertical: 8.0),
//                                             child: Text("$availableSlot slots",
//                                                 style: index ==
//                                                     bookSlotController
//                                                         .selectedDateIndex
//                                                     ? ConstFontStyle().headline1
//                                                     : ConstFontStyle()
//                                                     .titleText1!
//                                                     .copyWith(
//                                                   fontSize: 12,
//                                                 )),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                           );
//                         }),
//                   ),
//                 ),
//               ),
//               IconButton(
//                   onPressed: () {
//
//                   },
//                   icon: Icon(Icons.arrow_forward_ios_sharp,size: 20,)
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget get fullWidthPath {
//     return DottedBorder(
//       customPath: (size) {
//         return Path()
//           ..moveTo(0, 0)
//           ..lineTo(size.width, 0);
//       },
//       dashPattern: [5, 5],
//       // color: Colors.white,
//       color:ConstColor.backBtnColor,
//       child: Container(),
//     );
//   }
// }
//

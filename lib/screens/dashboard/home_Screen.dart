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
  final _dateScrollcontroller = ScrollController();
  final _scrollController = ScrollController();
  final dbref = FirebaseDatabase.instance.ref('Booking');

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    bookSlotController.selectedDate = now;
    bookSlotController.currentDate = now;

    for (int i = 1; i < 7; i++) {
      bookSlotController.next7Days.add(now.subtract(Duration(days: i)));
    }
    for (int i = 0; i < 6; i++) {
      bookSlotController.next7Days.add(now.add(Duration(days: i)));
    }
    bookSlotController.next7Days.sort((a, b) => a.compareTo(b));
    print(bookSlotController.next7Days);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {});
      _dateScrollcontroller.animateTo(
        _dateScrollcontroller.position.maxScrollExtent / 1,
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    final itemWidth = deviceWidth / 2; // You can adjust this value as needed
    final itemHeight = deviceHeight / 7; // You can adjust this value as needed

    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text("Book your next play", style: ConstFontStyle().titleText),
        // titleTextStyle :ConstFontStyle.titleText,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () {
                Get.to(() => MyBookingScreen());
              },
              child: SvgPicture.asset(
                ConstAsset.bookingIcon,
              )),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
            icon: Icon(
              Icons.person,
              color: ConstColor.greyTextColor,
            ),
            // color: ,
          )
        ],
      ),
      body: StreamBuilder(
        stream: dbref.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Map? bookingData = snapshot.data!.snapshot.value as Map?;
            print("bookingData : $bookingData");

            var practiseData = bookingData!['Practise'];
            print("practiseData : $practiseData");

            var userBookingsData = bookingData!['User_Bookings'];
            print("userBookingsData : $userBookingsData");

            bookSlotController.bookedSlotTimeList.clear();

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
                          child: Text(
                              formatDate(bookSlotController.selectedDate!)
                                  .toString(),
                              style: ConstFontStyle().buttonTextStyle),
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
                                    height: deviceHeight * 0.064,
                                    width: deviceWidth * 0.2,
                                    // height: deviceHeight * 0.067,
                                    // width: deviceWidth *0.2,
                                  ),
                                  Container(
                                    // height: deviceHeight * 2.1,
                                    height: deviceHeight * 1.99,
                                    width: deviceWidth * 0.2,
                                    // color: Colors.red,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount:
                                          bookSlotController.timeList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var value =
                                            bookSlotController.timeList[index];
                                        return AspectRatio(
                                          aspectRatio:
                                              (itemWidth / itemHeight) / 2.005,
                                          // 1.9997,
                                          child: Text(
                                              convertTo12HourFormat(value),
                                              textAlign: TextAlign.center,
                                              style: ConstFontStyle()
                                                  .titleText1!
                                                  .copyWith(fontSize: 12)),
                                        );
                                        // Padding(
                                        //   padding: EdgeInsets.only(bottom:  itemHeight
                                        //   // deviceHeight * 0.093
                                        //   ),
                                        //
                                        //   child:  Center(
                                        //       child: Text(convertTo12HourFormat(value),style: ConstFontStyle().titleText1!.copyWith(fontSize: 12))),
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
                                      // color: Colors.yellow,
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: ConstColor.lineColor,
                                        ), // Top border
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text('East Court',
                                                style: ConstFontStyle()
                                                    .titleText1),
                                          ),
                                        ),
                                        SizedBox(width: 9),
                                        Container(
                                          width: 1,
                                          color: ConstColor.lineColor,
                                          height: double.infinity,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Center(
                                            child: Text('West Court',
                                                style: ConstFontStyle()
                                                    .titleText1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: deviceHeight * 1.9747,
                                    // height: deviceHeight * 1.9,
                                    width: deviceWidth * 0.8,
                                    // color: Colors.white,
                                    child: GridView.builder(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      // physics: BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2, // Number of columns in the grid
                                        childAspectRatio: (itemWidth /
                                            itemHeight), // Aspect ratio of each grid item
                                      ),
                                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      //   crossAxisCount: 2,
                                      //   mainAxisSpacing: 0,
                                      //   childAspectRatio: 3 / 1.8,
                                      //   crossAxisSpacing: 0,
                                      // ),
                                      cacheExtent: 9999,
                                      itemCount:
                                          bookSlotController.slotList.length *
                                              2,
                                      itemBuilder: (context, index) {
                                        int timeIndex = index ~/ 2;
                                        // print(index);
                                        // print("timeIndex $timeIndex");

                                        String slotTime = bookSlotController
                                            .slotList[timeIndex];
                                        String halfHourSlotTime =
                                            adjustTimeRange(slotTime);
                                        String? previousSlotTime =
                                            timeIndex == 0
                                                ? null
                                                : bookSlotController
                                                    .slotList[timeIndex - 1];
                                        String? previousHalfHourSlotTime =
                                            previousSlotTime == null
                                                ? null
                                                : adjustTimeRange(
                                                    previousSlotTime);

                                        print(
                                            "halfHourSlotTime :$index : $halfHourSlotTime");
                                        // print("timeIndex : $timeIndex");
                                        // print("slotTime : $slotTime");
                                        // print("previousSlotTime : previousSlotTime");
                                        print(
                                            "previousHalfHourSlotTime : $previousHalfHourSlotTime");

                                        // print("slotTime :$index : $slotTime");/

                                        bool isCompletedOneHourSlot = false;
                                        bool isCompletedHalfHourSlot = false;
                                        bool isCompletedPreviousHalfHourSlot =
                                            false;

                                        DateTime currentTime = DateTime.now();
                                        print("currentTime :: $currentTime");

                                        // 1 Hour Current Slot
                                        List<String> dateComponents =
                                            bookSlotController.selectedDate!
                                                .toString()
                                                .substring(0, 10)
                                                .split("-");
                                        int year = int.parse(dateComponents[0]);
                                        int month =
                                            int.parse(dateComponents[1]);
                                        int day = int.parse(dateComponents[2]);

                                        List timeHoursList =
                                            convertSlotToTimeHoursFrom(
                                                slotTime: slotTime,
                                                year: year,
                                                month: month,
                                                day: day);
                                        List<String> timeHoursFrom =
                                            timeHoursList[0];
                                        List<String> timeHoursTo =
                                            timeHoursList[1];
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

                                        // Half Hour Current Slot
                                        List timeHoursList1 =
                                            convertSlotToTimeHoursFrom(
                                                slotTime: halfHourSlotTime,
                                                year: year,
                                                month: month,
                                                day: day);
                                        List<String> timeHoursFrom1 =
                                            timeHoursList1[0];
                                        List<String> timeHoursTo1 =
                                            timeHoursList1[1];
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

                                        // Previous Half Hour Current Slot
                                        List timeHoursList2 = [];
                                        DateTime? slotFromTime2 = null;

                                        if (previousHalfHourSlotTime != null) {
                                          timeHoursList2 =
                                              convertSlotToTimeHoursFrom(
                                                  slotTime:
                                                      previousHalfHourSlotTime!,
                                                  year: year,
                                                  month: month,
                                                  day: day);
                                          List<String> timeHoursFrom2 =
                                              timeHoursList2[0];
                                          List<String> timeHoursTo2 =
                                              timeHoursList2[1];
                                          slotFromTime2 = DateTime(
                                            year,
                                            month,
                                            day,
                                            int.parse(timeHoursFrom2[0]),
                                            int.parse(timeHoursTo2[1]),
                                          );
                                          isCompletedPreviousHalfHourSlot =
                                              currentTime
                                                  .isAfter(slotFromTime2);
                                        }

                                        isCompletedOneHourSlot =
                                            currentTime.isAfter(slotFromTime);
                                        print(
                                            "isCompletedOneHourSlot : $isCompletedOneHourSlot");
                                        isCompletedHalfHourSlot =
                                            currentTime.isAfter(slotFromTime1);

                                        String courtId =
                                            index % 2 == 0 ? 'EC' : 'WC';
                                        bool isPractiseSlot = false;
                                        bool isPractiseSlotOneHour = false;
                                        bool isPractiseSlotHalfHour = false;
                                        bool isPractiseSlotFirstHalf = false;
                                        bool isPractiseSlotSecondHalf = false;

                                        String practiseSlotTime = '';


                                        if (courtId == 'EC') {

                                          for (int i = 1; i <= practiseData['EC'].length; i++) {
                                            Map slotList = practiseData['EC']['slotList${i.toString()}'];
                                            print("slotList index $i $slotList");
                                            print("dayNameList ${slotList['dayName']}");

                                            List<String> daysList = slotList['dayName'].toString().split(',').map((day) => day.trim()).toList();
                                            print("daysList $daysList");

                                            String dayName =
                                            DateFormat('EEEE').format(bookSlotController.selectedDate!).substring(0, 3);

                                            print("dayName000 $dayName");

                                            bool isDayInList = daysList.contains(dayName.toLowerCase());
                                            print("isDayInList $isDayInList");

                                            if(isDayInList) {
                                              if (slotList
                                                  .length !=
                                                  0) {
                                                print("ala");

                                                for (int i = 1;
                                                i <= slotList.length -1;
                                                i++) {
                                                  print("slotList i00+++" + i.toString());
                                                  // print("slotList data" + slotList.toString());
                                                  // print("slotList data" + slotList['slot1'].toString());


                                                  var slot = slotList["slot${i.toString()}"];
                                                  print("sloti+++" + slot.toString());
                                                  String practiseSlot =
                                                      slot['from'] +
                                                          " - " +
                                                          slot['to'];
                                                  print("practiseSlot000 : $practiseSlot");
                                                  print("slotTime0000 : $slotTime");
                                                  // print("slotTime : $slotTime");

                                                  bool match =
                                                      slotTime == practiseSlot;
                                                  print("match000 : $match");

                                                  if (match) {
                                                    isPractiseSlot = true;
                                                    isPractiseSlotOneHour = true;
                                                    practiseSlotTime = practiseSlot;
                                                    bookSlotController
                                                        .bookedSlotTimeList
                                                        .add({
                                                      courtId: practiseSlot
                                                    });
                                                    // bookSlotController.bookedSlotTimeList.add(practiseSlot);
                                                  } else {
                                                    String fromIn24Hours =
                                                    convertTo24HourFormat(
                                                        slot['from']);
                                                    String toIn24Hours =
                                                    convertTo24HourFormat(
                                                        slot['to']);
                                                    // print("fromIn24Hours : $fromIn24Hours");

                                                    List<String> checkFromTime =
                                                    fromIn24Hours.split(':');
                                                    List<String> checkFromTime2 =
                                                    toIn24Hours.split(':');

                                                    DateTime fromTimeInDT =
                                                    DateTime(
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

                                                    bool isFromTimeBetweenInSlot =
                                                    isBetweenInTimeRange(
                                                        timeSlot: [
                                                          slotFromTime,
                                                          slotToTime
                                                        ],
                                                        checkTime:
                                                        fromTimeInDT);
                                                    bool istoTimeBetweenInSlot =
                                                    isBetweenInTimeRange(
                                                        timeSlot: [
                                                          slotFromTime,
                                                          slotToTime
                                                        ],
                                                        checkTime: toTimeInDT);
                                                    print(
                                                        "isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                    // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                    if (isFromTimeBetweenInSlot) {
                                                      isPractiseSlot = true;
                                                      isPractiseSlotHalfHour = true;
                                                      isPractiseSlotFirstHalf =
                                                      true;
                                                      practiseSlotTime =
                                                          practiseSlot;
                                                    } else if (istoTimeBetweenInSlot) {
                                                      isPractiseSlot = true;
                                                      isPractiseSlotHalfHour = true;
                                                      isPractiseSlotSecondHalf =
                                                      true;
                                                    }
                                                  }
                                                }
                                              }
                                            }

                                          }

                                        } else {
                                          for (int i = 1; i <= practiseData['WC'].length; i++) {
                                            Map slotList = practiseData['WC']['slotList${i.toString()}'];
                                            print("slotList index $i $slotList");
                                            print("dayNameList ${slotList['dayName']}");

                                            List<String> daysList = slotList['dayName'].toString().split(',').map((day) => day.trim()).toList();
                                            print("daysList $daysList");

                                            String dayName =
                                            DateFormat('EEEE').format(bookSlotController.selectedDate!).substring(0, 3);

                                            print("dayName000 $dayName");

                                            bool isDayInList = daysList.contains(dayName.toLowerCase());
                                            print("isDayInList $isDayInList");

                                            if(isDayInList) {
                                              if (slotList
                                                  .length !=
                                                  0) {
                                                print("ala");

                                                for (int i = 1;
                                                i <= slotList.length -1;
                                                i++) {
                                                  print("slotList i00+++" + i.toString());
                                                  // print("slotList data" + slotList.toString());
                                                  // print("slotList data" + slotList['slot1'].toString());


                                                  var slot = slotList["slot${i.toString()}"];
                                                  print("sloti+++" + slot.toString());
                                                  String practiseSlot =
                                                      slot['from'] +
                                                          " - " +
                                                          slot['to'];
                                                  print("practiseSlot000 : $practiseSlot");
                                                  print("slotTime0000 : $slotTime");
                                                  // print("slotTime : $slotTime");

                                                  bool match =
                                                      slotTime == practiseSlot;
                                                  print("match000 : $match");

                                                  if (match) {
                                                    isPractiseSlot = true;
                                                    isPractiseSlotOneHour = true;
                                                    practiseSlotTime = practiseSlot;
                                                    bookSlotController
                                                        .bookedSlotTimeList
                                                        .add({
                                                      courtId: practiseSlot
                                                    });
                                                    // bookSlotController.bookedSlotTimeList.add(practiseSlot);
                                                  } else {
                                                    String fromIn24Hours =
                                                    convertTo24HourFormat(
                                                        slot['from']);
                                                    String toIn24Hours =
                                                    convertTo24HourFormat(
                                                        slot['to']);
                                                    // print("fromIn24Hours : $fromIn24Hours");

                                                    List<String> checkFromTime =
                                                    fromIn24Hours.split(':');
                                                    List<String> checkFromTime2 =
                                                    toIn24Hours.split(':');

                                                    DateTime fromTimeInDT =
                                                    DateTime(
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

                                                    bool isFromTimeBetweenInSlot =
                                                    isBetweenInTimeRange(
                                                        timeSlot: [
                                                          slotFromTime,
                                                          slotToTime
                                                        ],
                                                        checkTime:
                                                        fromTimeInDT);
                                                    bool istoTimeBetweenInSlot =
                                                    isBetweenInTimeRange(
                                                        timeSlot: [
                                                          slotFromTime,
                                                          slotToTime
                                                        ],
                                                        checkTime: toTimeInDT);
                                                    print(
                                                        "isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                    // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");

                                                    if (isFromTimeBetweenInSlot) {
                                                      isPractiseSlot = true;
                                                      isPractiseSlotHalfHour = true;
                                                      isPractiseSlotFirstHalf =
                                                      true;
                                                      practiseSlotTime =
                                                          practiseSlot;
                                                    } else if (istoTimeBetweenInSlot) {
                                                      isPractiseSlot = true;
                                                      isPractiseSlotHalfHour = true;
                                                      isPractiseSlotSecondHalf =
                                                      true;
                                                    }
                                                  }
                                                }
                                              }
                                            }

                                          }


                                          // print("length WC : ${practiseData['WC']['slotList'].length}");

                                          // if (practiseData['WC']['slotList']
                                          //         .length !=
                                          //     0) {
                                          //   for (int i = 1;
                                          //       i <=
                                          //           practiseData['WC']
                                          //                   ['slotList']
                                          //               .length;
                                          //       i++) {
                                          //     // print("i+++" + i.toString());
                                          //     var slot = practiseData['WC']
                                          //             ['slotList']
                                          //         ["slot${i.toString()}"];
                                          //     // print("sloti+++" + slot.toString());
                                          //
                                          //     String practiseSlot =
                                          //         slot['from'] +
                                          //             " - " +
                                          //             slot['to'];
                                          //     // print("practiseSlot000 : $practiseSlot");
                                          //     // print("slotTime0000 : $slotTime");
                                          //     // print("slotTime : $slotTime");
                                          //
                                          //     bool match =
                                          //         slotTime == practiseSlot;
                                          //     // print("match000 : $match");
                                          //
                                          //     if (match) {
                                          //       isPractiseSlot = true;
                                          //       isPractiseSlotOneHour = true;
                                          //       practiseSlotTime = practiseSlot;
                                          //       bookSlotController
                                          //           .bookedSlotTimeList
                                          //           .add({
                                          //         courtId: practiseSlot
                                          //       });
                                          //     } else {
                                          //       String fromIn24Hours =
                                          //           convertTo24HourFormat(
                                          //               slot['from']);
                                          //       String toIn24Hours =
                                          //           convertTo24HourFormat(
                                          //               slot['to']);
                                          //       // print("fromIn24Hours : $fromIn24Hours");
                                          //
                                          //       List<String> checkFromTime =
                                          //           fromIn24Hours.split(':');
                                          //       List<String> checkFromTime2 =
                                          //           toIn24Hours.split(':');
                                          //
                                          //       DateTime fromTimeInDT =
                                          //           DateTime(
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
                                          //       bool isFromTimeBetweenInSlot =
                                          //           isBetweenInTimeRange(
                                          //               timeSlot: [
                                          //             slotFromTime,
                                          //             slotToTime
                                          //           ],
                                          //               checkTime:
                                          //                   fromTimeInDT);
                                          //       bool istoTimeBetweenInSlot =
                                          //           isBetweenInTimeRange(
                                          //               timeSlot: [
                                          //             slotFromTime,
                                          //             slotToTime
                                          //           ],
                                          //               checkTime: toTimeInDT);
                                          //       // print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                          //       // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");
                                          //
                                          //       if (isFromTimeBetweenInSlot) {
                                          //         isPractiseSlot = true;
                                          //         isPractiseSlotHalfHour = true;
                                          //         isPractiseSlotFirstHalf =
                                          //             true;
                                          //         practiseSlotTime =
                                          //             practiseSlot;
                                          //       } else if (istoTimeBetweenInSlot) {
                                          //         isPractiseSlot = true;
                                          //         isPractiseSlotHalfHour = true;
                                          //         isPractiseSlotSecondHalf =
                                          //             true;
                                          //       }
                                          //     }
                                          //   }
                                          // }
                                        }

                                        print(
                                            "isPractiseSlotHalfHour++ : $isPractiseSlotHalfHour $index");
                                        print(
                                            "isPractiseSlotFirstHalf+++ : $index $isPractiseSlotFirstHalf");

                                        if (isPractiseSlot) {
                                          return Builder(
                                            builder: (context) {
                                              if (isPractiseSlotOneHour) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        width: 1.0,
                                                        color: ConstColor
                                                            .lineColor,
                                                      ), // Top border
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
                                                          deviceHeight * 0.09,
                                                      width: deviceWidth * 0.33,
                                                      decoration: BoxDecoration(
                                                          color: ConstColor
                                                              .highLightBooking,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom:
                                                                    deviceHeight *
                                                                        0.015,
                                                                left:
                                                                    deviceWidth *
                                                                        0.01),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                practiseSlotTime
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: ConstFontStyle()
                                                                    .titleText1!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                                child:
                                                                    fullWidthPath),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  top:
                                                                      deviceHeight *
                                                                          0.01,
                                                                  left:
                                                                      deviceWidth *
                                                                          0.015),
                                                              child: Text(
                                                                  // time.toString(),
                                                                  "Kids Coaching Slot",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: ConstFontStyle()
                                                                      .smallText),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else if (isPractiseSlotHalfHour) {
                                                if (isPractiseSlotFirstHalf &&
                                                    isPractiseSlotSecondHalf) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Top border
                                                        right: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Right border
                                                      ),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          deviceHeight * 0.09,
                                                      width: deviceWidth * 0.33,
                                                      decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                // print(slotTime);
                                                                // print(courtId);
                                                                // bookSlotController.selectedSlotIndex.value = index;
                                                                // bookSlotController.selectedSlotTime = slotTime ;
                                                                // bookSlotController.selectedCourtId = courtId;
                                                                // bookSlotController.selectedisCompletedOneHourSlot = isCompletedOneHourSlot;
                                                                // setState(() {
                                                                // });
                                                              },
                                                              child: Container(
                                                                  width:
                                                                      deviceWidth *
                                                                          0.33,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ConstColor
                                                                        .highLightBooking,
                                                                    borderRadius: BorderRadius.only(
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                5),
                                                                        bottomLeft:
                                                                            Radius.circular(5)),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: deviceHeight *
                                                                              0.01,
                                                                          left: deviceWidth *
                                                                              0.015),
                                                                      child: Text(
                                                                          "Kids Coaching Slot",
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              ConstFontStyle().smallText),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                          Container(
                                                              child:
                                                                  fullWidthPath),
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                // color: ConstColor.childrenBooking,
                                                                // height: deviceHeight * 0.09,
                                                                width:
                                                                    deviceWidth *
                                                                        0.33,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ConstColor
                                                                      .highLightBooking,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              5),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    practiseSlotTime
                                                                        .toString(),
                                                                    style: ConstFontStyle()
                                                                        .titleText1!
                                                                        .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else if (isPractiseSlotFirstHalf) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Top border
                                                        right: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Right border
                                                      ),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          deviceHeight * 0.09,
                                                      width: deviceWidth * 0.33,
                                                      decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {

                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            fit: FlexFit.tight,
                                                            child: Container(
                                                                child:
                                                                    fullWidthPath),
                                                          ),
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child: Container(
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ConstColor
                                                                    .highLightBooking,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5)),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  // "0",
                                                                  practiseSlotTime
                                                                      .toString(),
                                                                  style: ConstFontStyle()
                                                                      .titleText1!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else if (isPractiseSlotSecondHalf) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Top border
                                                        right: BorderSide(
                                                          width: 1.0,
                                                          color: ConstColor
                                                              .lineColor,
                                                        ), // Right border
                                                      ),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          deviceHeight * 0.09,
                                                      width: deviceWidth * 0.33,
                                                      decoration: BoxDecoration(
                                                          // color: ConstColor.primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                  width:
                                                                      deviceWidth *
                                                                          0.33,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ConstColor
                                                                        .highLightBooking,
                                                                    borderRadius: BorderRadius.only(
                                                                        bottomRight:
                                                                            Radius.circular(
                                                                                5),
                                                                        bottomLeft:
                                                                            Radius.circular(5)),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: deviceHeight *
                                                                              0.01,
                                                                          left: deviceWidth *
                                                                              0.015),
                                                                      child: Text(
                                                                          "Kids Coaching Slot",
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                              ConstFontStyle().smallText),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                          Container(
                                                              child:
                                                                  fullWidthPath),
                                                          Flexible(
                                                            flex: 10,
                                                            fit: FlexFit.tight,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                // String
                                                                // targetedSlot =
                                                                // bookSlotController.slotList[timeIndex +
                                                                //     1];
                                                                // bool
                                                                // isAbelToSelect =
                                                                // bookSlotController.checkUserAbelToSelectSlot(targetedValue: {
                                                                //   courtId:
                                                                //   targetedSlot
                                                                // });
                                                                //
                                                                // if (isAbelToSelect) {
                                                                //   // print(courtId);
                                                                //   bookSlotController
                                                                //       .selectedSlotIndex
                                                                //       .value = index;
                                                                //   bookSlotController.selectedSlotTime =
                                                                //       halfHourSlotTime;
                                                                //   bookSlotController.selectedCourtId =
                                                                //       courtId;
                                                                //   bookSlotController.selectedIsCompleted =
                                                                //       isCompletedHalfHourSlot;
                                                                //   setState(
                                                                //           () {});
                                                                // } else {
                                                                //   Utils()
                                                                //       .snackBar(message: "Slot is not available, please select other slot.");
                                                                // }

                                                                /* */
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
                                                                color: Colors
                                                                    .transparent,
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
                                            stream: dbref
                                                .child('User_Bookings')
                                                .orderByChild('date')
                                                .equalTo(bookSlotController
                                                    .selectedDate!
                                                    .toString()
                                                    .substring(0, 10))
                                                .onValue,
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              } else {
                                                Map? bookData = snapshot.data!
                                                    .snapshot.value as Map?;
                                                // print("bookingData00001 : $bookingData");

                                                bool isBookedSlot = false;
                                                bool bookedSlotIsYour = false;
                                                bool isBookedSlotOneHour =
                                                    false;
                                                bool isBookedSlotHalfHour =
                                                    false;
                                                bool isBookedSlotFirstHalf =
                                                    false;
                                                bool isBookedSlotSecondHalf =
                                                    false;

                                                String bookedTime = '';
                                                String userId = "";
                                                // Select Slot
                                                // bool isSelectedSlot = false;
                                                // bool isSelectedSlotIsHalfHour = false;
                                                // bool isSelectedSlotHour = false;

                                                if (bookData != null) {
                                                  bookData
                                                      .forEach((key, value) {
                                                    if (value['courtId'] ==
                                                        courtId) {
                                                      String bookedSlotTime =
                                                          value['from'] +
                                                              " - " +
                                                              value['to'];

                                                      bool match = slotTime ==
                                                          bookedSlotTime;
                                                      // bool matchIsHalfHour = slotTime == bookedSlotTime || slotTime == halfHourSlotTime;
                                                      // print("match $match");
                                                      if (match) {
                                                        userId =
                                                            value['userId'];
                                                        isBookedSlot = true;
                                                        isBookedSlotOneHour =
                                                            true;
                                                        bookedTime =
                                                            bookedSlotTime;

                                                        bool isContains =
                                                            bookSlotController
                                                                .bookedSlotTimeList
                                                                .any((map) =>
                                                                    map.toString() ==
                                                                    {
                                                                      courtId:
                                                                          bookedSlotTime
                                                                    }.toString());

                                                        if (!isContains) {
                                                          bookSlotController
                                                              .bookedSlotTimeList
                                                              .add({
                                                            courtId:
                                                                bookedSlotTime
                                                          });
                                                        }

                                                        bookedSlotIsYour =
                                                            bookSlotController
                                                                    .auth
                                                                    .currentUser
                                                                    ?.uid ==
                                                                value['userId'];
                                                        // isSelectedSlot = true;
                                                      } else {
                                                        // isSelectedSlot = false;

                                                        String fromIn24Hours =
                                                            convertTo24HourFormat(
                                                                value['from']);
                                                        String toIn24Hours =
                                                            convertTo24HourFormat(
                                                                value['to']);
                                                        // print("fromIn24Hours : $fromIn24Hours");

                                                        List<String>
                                                            checkFromTime =
                                                            fromIn24Hours
                                                                .split(':');
                                                        List<String>
                                                            checkFromTime2 =
                                                            toIn24Hours
                                                                .split(':');

                                                        DateTime fromTimeInDT =
                                                            DateTime(
                                                          year,
                                                          month,
                                                          day,
                                                          int.parse(
                                                              checkFromTime[0]),
                                                          int.parse(
                                                              checkFromTime[1]),
                                                        );
                                                        DateTime toTimeInDT =
                                                            DateTime(
                                                          year,
                                                          month,
                                                          day,
                                                          int.parse(
                                                              checkFromTime2[
                                                                  0]),
                                                          int.parse(
                                                              checkFromTime2[
                                                                  1]),
                                                        );
                                                        // print("fromTimeInDT $fromTimeInDT");

                                                        bool
                                                            isFromTimeBetweenInSlot =
                                                            isBetweenInTimeRange(
                                                                timeSlot: [
                                                              slotFromTime,
                                                              slotToTime
                                                            ],
                                                                checkTime:
                                                                    fromTimeInDT);
                                                        bool
                                                            istoTimeBetweenInSlot =
                                                            isBetweenInTimeRange(
                                                                timeSlot: [
                                                              slotFromTime,
                                                              slotToTime
                                                            ],
                                                                checkTime:
                                                                    toTimeInDT);
                                                        // print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                        // print("istoTimeBetweenInSlot:  $index ${istoTimeBetweenInSlot}");
                                                        if (isFromTimeBetweenInSlot) {
                                                          bookedSlotIsYour =
                                                              bookSlotController
                                                                      .auth
                                                                      .currentUser
                                                                      ?.uid ==
                                                                  value[
                                                                      'userId'];
                                                          userId =
                                                              value['userId'];
                                                          isBookedSlot = true;
                                                          isBookedSlotHalfHour =
                                                              true;
                                                          isBookedSlotFirstHalf =
                                                              true;
                                                          bookedTime =
                                                              bookedSlotTime;
                                                        } else if (istoTimeBetweenInSlot) {
                                                          bookedSlotIsYour =
                                                              bookSlotController
                                                                      .auth
                                                                      .currentUser
                                                                      ?.uid ==
                                                                  value[
                                                                      'userId'];
                                                          userId =
                                                              value['userId'];
                                                          isBookedSlot = true;
                                                          isBookedSlotHalfHour =
                                                              true;
                                                          isBookedSlotSecondHalf =
                                                              true;
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
                                                bool isSelectedSlotOneHour =
                                                    false;
                                                bool isSelectedSlotHalfHour =
                                                    false;
                                                bool isSelectedSlotFirstHalf =
                                                    false;
                                                bool isSelectedSlotSecondHalf =
                                                    false;

                                                if (bookSlotController
                                                        .selectedSlotTime !=
                                                    null) {
                                                  if (bookSlotController
                                                          .selectedCourtId ==
                                                      courtId) {
                                                    isSelected = slotTime ==
                                                        bookSlotController
                                                            .selectedSlotTime;
                                                    if (isSelected) {
                                                      isSelectedSlotOneHour =
                                                          slotTime ==
                                                              bookSlotController
                                                                  .selectedSlotTime;
                                                    } else {
                                                      List<String> times =
                                                          bookSlotController
                                                              .selectedSlotTime!
                                                              .split(" - ");
                                                      String fromTime =
                                                          times[0];
                                                      String toTime = times[1];

                                                      String fromIn24Hours =
                                                          convertTo24HourFormat(
                                                              fromTime);
                                                      String toIn24Hours =
                                                          convertTo24HourFormat(
                                                              toTime);
                                                      print(
                                                          "slotTime++ : $slotTime");
                                                      print(
                                                          "halfHourSlotTime++ : $halfHourSlotTime");
                                                      print(
                                                          "fromIn24Hours++ : $fromIn24Hours");
                                                      print(
                                                          "toIn24Hours : $toIn24Hours");

                                                      List<String>
                                                          checkFromTime =
                                                          fromIn24Hours
                                                              .split(':');
                                                      List<String>
                                                          checkFromTime2 =
                                                          toIn24Hours
                                                              .split(':');

                                                      DateTime fromTimeInDT =
                                                          DateTime(
                                                        year,
                                                        month,
                                                        day,
                                                        int.parse(
                                                            checkFromTime[0]),
                                                        int.parse(
                                                            checkFromTime[1]),
                                                      );
                                                      DateTime toTimeInDT =
                                                          DateTime(
                                                        year,
                                                        month,
                                                        day,
                                                        int.parse(
                                                            checkFromTime2[0]),
                                                        int.parse(
                                                            checkFromTime2[1]),
                                                      );
                                                      print(
                                                          "fromTimeInDT $fromTimeInDT");
                                                      print(
                                                          "toTimeInDT $toTimeInDT");

                                                      print(
                                                          "slotFromTime $slotFromTime");
                                                      print(
                                                          "slotToTime $slotToTime");

                                                      bool isFromTimeBetweenInSlot =
                                                          isBetweenInTimeRange(
                                                              timeSlot: [
                                                            slotFromTime,
                                                            slotToTime
                                                          ],
                                                              checkTime:
                                                                  fromTimeInDT);
                                                      bool istoTimeBetweenInSlot =
                                                          isBetweenInTimeRange(
                                                              timeSlot: [
                                                            slotFromTime,
                                                            slotToTime
                                                          ],
                                                              checkTime:
                                                                  toTimeInDT);
                                                      // print("isFromTimeBetweenInSlot : $index ${isFromTimeBetweenInSlot}");
                                                      print(
                                                          "isFromTimeBetweenInSlot++ : $index ${isFromTimeBetweenInSlot}");
                                                      print(
                                                          "istoTimeBetweenInSlot++ : $index ${istoTimeBetweenInSlot}");

                                                      if (isFromTimeBetweenInSlot) {
                                                        isSelected = true;
                                                        isSelectedSlotHalfHour =
                                                            true;
                                                        isSelectedSlotFirstHalf =
                                                            true;
                                                        // bookedTime = bookedSlotTime;
                                                      } else if (istoTimeBetweenInSlot) {
                                                        isSelected = true;
                                                        isSelectedSlotHalfHour =
                                                            true;
                                                        isSelectedSlotSecondHalf =
                                                            true;
                                                      }
                                                    }
                                                  } else {}
                                                }

                                                return Builder(
                                                  builder: (context) {
                                                    if (isBookedSlot) {
                                                      if (isBookedSlotOneHour) {
                                                        //
                                                        return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              // color: C,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ),
                                                                // Top border
                                                                right:
                                                                    BorderSide(
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
                                                                        0.096,
                                                                width:
                                                                    deviceWidth *
                                                                        0.34,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            2,
                                                                        horizontal:
                                                                            3),
                                                                decoration: BoxDecoration(
                                                                    color: ConstColor
                                                                        .highLightBooking,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Container(
                                                                        width: deviceWidth *
                                                                            0.33,
                                                                        height: deviceHeight *
                                                                            0.043,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ConstColor.highLightBooking,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(5),
                                                                              topRight: Radius.circular(5)),
                                                                          // BorderRadius.circular(5)
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: deviceHeight * 0.01,
                                                                              left: 2),
                                                                          child: Text(
                                                                              isCompletedOneHourSlot ? "Completed" : slotTime,
                                                                              style: ConstFontStyle().titleText1!.copyWith(
                                                                                    fontSize: 11,
                                                                                  ),
                                                                              textAlign: TextAlign.left),
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
                                                                    Container(
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      height: deviceHeight *
                                                                          0.047,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ConstColor
                                                                            .highLightBooking,
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(5),
                                                                            bottomRight: Radius.circular(5)),
                                                                        // BorderRadius.circular(5)
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: deviceHeight *
                                                                                0.01,
                                                                            left:
                                                                                2),
                                                                        child:
                                                                            StreamBuilder(
                                                                          stream: bookSlotController
                                                                              .dbRefUser
                                                                              .child(userId.toString())
                                                                              .onValue,
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (!snapshot.hasData) {
                                                                              return Text(
                                                                                bookedSlotIsYour ? "Your Booking" : "Other",
                                                                                textAlign: TextAlign.left,
                                                                                style: ConstFontStyle().titleText1,
                                                                              );
                                                                            } else {
                                                                              Map? userDetails = snapshot.data!.snapshot.value as Map?;
                                                                              // print("userName : $userName");
                                                                              String userName = userDetails!['UserName'].toString();
                                                                              // print(
                                                                              //     "userName : $userName");

                                                                              return Text(
                                                                                bookedSlotIsYour ? "Your Booking" : userName,
                                                                                textAlign: TextAlign.left,
                                                                                style: ConstFontStyle().titleText1,
                                                                              );
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )

                                                            // Center(
                                                            //   child: Container(
                                                            //     height:
                                                            //     deviceHeight *
                                                            //         0.09,
                                                            //     width: deviceWidth *
                                                            //         0.33,
                                                            //     padding: EdgeInsets
                                                            //         .symmetric(
                                                            //         vertical: 2,
                                                            //         horizontal:
                                                            //         3),
                                                            //     decoration: BoxDecoration(
                                                            //         color: ConstColor
                                                            //             .highLightBooking,
                                                            //         borderRadius:
                                                            //         BorderRadius
                                                            //             .circular(
                                                            //             5)),
                                                            //     child: Column(
                                                            //       mainAxisAlignment:
                                                            //       MainAxisAlignment
                                                            //           .center,
                                                            //       crossAxisAlignment:
                                                            //       CrossAxisAlignment
                                                            //           .center,
                                                            //       children: [
                                                            //         Text(
                                                            //             isCompletedOneHourSlot
                                                            //                 ? "Completed"
                                                            //                 : slotTime,
                                                            //             style: ConstFontStyle()
                                                            //                 .titleText1!
                                                            //                 .copyWith(
                                                            //               fontSize:
                                                            //               12,
                                                            //             ),
                                                            //             textAlign:
                                                            //             TextAlign
                                                            //                 .center),
                                                            //         SizedBox(
                                                            //           height: 3,
                                                            //         ),
                                                            //         StreamBuilder(
                                                            //           stream: bookSlotController
                                                            //               .dbRefUser
                                                            //               .child(userId
                                                            //               .toString())
                                                            //               .onValue,
                                                            //           builder: (context,
                                                            //               snapshot) {
                                                            //             if (!snapshot
                                                            //                 .hasData) {
                                                            //               return Text(
                                                            //                 bookedSlotIsYour
                                                            //                     ? "Your Booking"
                                                            //                     : "Other",
                                                            //                 textAlign:
                                                            //                 TextAlign.center,
                                                            //                 style: ConstFontStyle()
                                                            //                     .titleText1,
                                                            //               );
                                                            //             } else {
                                                            //               Map? userDetails = snapshot
                                                            //                   .data!
                                                            //                   .snapshot
                                                            //                   .value as Map?;
                                                            //               // print("userName : $userName");
                                                            //               String
                                                            //               userName =
                                                            //               userDetails!['UserName']
                                                            //                   .toString();
                                                            //               // print(
                                                            //               //     "userName : $userName");
                                                            //
                                                            //               return Text(
                                                            //                 bookedSlotIsYour
                                                            //                     ? "Your Booking"
                                                            //                     : userName,
                                                            //                 textAlign:
                                                            //                 TextAlign.center,
                                                            //                 style: ConstFontStyle()
                                                            //                     .titleText1,
                                                            //               );
                                                            //             }
                                                            //           },
                                                            //         ),
                                                            //         // Text(isCompletedOneHourSlot ? "Completed" : "" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            );
                                                      } else if (isBookedSlotHalfHour) {
                                                        if (isBookedSlotFirstHalf &&
                                                            isBookedSlotSecondHalf) {
                                                          //
                                                          print(
                                                              "isBookedSlotFirstHalf");
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Top border
                                                                right:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Right border
                                                              ),
                                                            ),
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.09,
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: ConstColor.primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
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
                                                                          width: deviceWidth * 0.33,
                                                                          margin: EdgeInsets.only(bottom: 5),
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                ConstColor.highLightBooking,
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                                          ),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                            child:
                                                                                StreamBuilder(
                                                                              stream: bookSlotController.dbRefUser.child(userId.toString()).onValue,
                                                                              builder: (context, snapshot) {
                                                                                if (!snapshot.hasData) {
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : "Other",
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                } else {
                                                                                  Map? userDetails = snapshot.data!.snapshot.value as Map?;
                                                                                  // print("userName : $userName");
                                                                                  String userName = userDetails!['UserName'].toString();
                                                                                  // print("userName00011 : $userName");
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : userName,
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                          )),
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
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Container(
                                                                        // color: ConstColor.childrenBooking,
                                                                        // height: deviceHeight * 0.09,
                                                                        width: deviceWidth *
                                                                            0.33,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ConstColor.highLightBooking,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(5),
                                                                              topRight: Radius.circular(5)),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: deviceHeight * 0.01,
                                                                              left: 2),
                                                                          child:
                                                                              Text(
                                                                            bookedTime.toString(),
                                                                            style: ConstFontStyle().titleText1!.copyWith(
                                                                                  fontSize: 11,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else if (isBookedSlotFirstHalf &&
                                                            isSelectedSlotSecondHalf) {
                                                          //
                                                          print(
                                                              "isBookedSlotFirstHalf");
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Top border
                                                                right:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Right border
                                                              ),
                                                            ),
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.09,
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: ConstColor.primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child: Container(
                                                                          width: deviceWidth * 0.33,
                                                                          margin: EdgeInsets.only(bottom: 5),
                                                                          decoration: BoxDecoration(
                                                                            color: isCompletedPreviousHalfHourSlot
                                                                                ? ConstColor.greyTextColor
                                                                                : ConstColor.highlightBooking,
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                                          ),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                            child:
                                                                                Text(
                                                                              // isCompletedHalfHourSlot
                                                                              isCompletedPreviousHalfHourSlot ? "Completed" : "Available",
                                                                              // bookSlotController.selectedSlotTime.toString(),
                                                                              style: ConstFontStyle().titleText1!.copyWith(fontSize: 14),
                                                                            ),
                                                                          )),
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
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        Container(
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ConstColor
                                                                            .highLightBooking,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(5),
                                                                            topRight: Radius.circular(5)),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: deviceHeight *
                                                                                0.01,
                                                                            left:
                                                                                2),
                                                                        child:
                                                                            Text(
                                                                          bookedTime
                                                                              .toString(),
                                                                          style: ConstFontStyle()
                                                                              .titleText1!
                                                                              .copyWith(
                                                                                fontSize: 11,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else if (isBookedSlotFirstHalf) {
                                                          //
                                                          print(
                                                              "isBookedSlotFirstHalf");
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Top border
                                                                right:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Right border
                                                              ),
                                                            ),
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.09,
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: ConstColor.primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
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
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        Container(
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ConstColor
                                                                            .highLightBooking,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(5),
                                                                            topRight: Radius.circular(5)),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: deviceHeight *
                                                                                0.01,
                                                                            left:
                                                                                2),
                                                                        child:
                                                                            Text(
                                                                          bookedTime
                                                                              .toString(),
                                                                          style: ConstFontStyle()
                                                                              .titleText1!
                                                                              .copyWith(
                                                                                fontSize: 11,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else if (isBookedSlotSecondHalf &&
                                                            isSelectedSlotFirstHalf) {
                                                          //
                                                          print(
                                                              "isBookedSlotSecondHalf");
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Top border
                                                                right:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Right border
                                                              ),
                                                            ),
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.09,
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: ConstColor.primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child: Container(
                                                                          width: deviceWidth * 0.33,
                                                                          margin: EdgeInsets.only(bottom: 5),
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                ConstColor.highLightBooking,
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                                          ),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                            child:
                                                                                StreamBuilder(
                                                                              stream: bookSlotController.dbRefUser.child(userId.toString()).onValue,
                                                                              builder: (context, snapshot) {
                                                                                if (!snapshot.hasData) {
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : "Other",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                } else {
                                                                                  Map? userDetails = snapshot.data!.snapshot.value as Map?;
                                                                                  // print("userName : $userName");
                                                                                  String userName = userDetails!['UserName'].toString();
                                                                                  // print("userName00011 : $userName");
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : userName,
                                                                                    textAlign: TextAlign.center,
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                          )),
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
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        Container(
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: isCompletedHalfHourSlot
                                                                            ? ConstColor.greyTextColor
                                                                            : ConstColor.highlightBooking,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(5),
                                                                            topRight: Radius.circular(5)),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: deviceHeight *
                                                                                0.01,
                                                                            left:
                                                                                2),
                                                                        child:
                                                                            Text(
                                                                          bookSlotController
                                                                              .selectedSlotTime
                                                                              .toString(),
                                                                          style: ConstFontStyle()
                                                                              .titleText1!
                                                                              .copyWith(fontSize: 11),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else if (isBookedSlotSecondHalf) {
                                                          //
                                                          print(
                                                              "isBookedSlotSecondHalf");
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Top border
                                                                right:
                                                                    BorderSide(
                                                                  width: 1.0,
                                                                  color: ConstColor
                                                                      .lineColor,
                                                                ), // Right border
                                                              ),
                                                            ),
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.09,
                                                              width:
                                                                  deviceWidth *
                                                                      0.33,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      // color: ConstColor.primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child: Container(
                                                                          width: deviceWidth * 0.33,
                                                                          margin: EdgeInsets.only(bottom: 5),
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                ConstColor.highLightBooking,
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                                          ),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                            child:
                                                                                StreamBuilder(
                                                                              stream: bookSlotController.dbRefUser.child(userId.toString()).onValue,
                                                                              builder: (context, snapshot) {
                                                                                if (!snapshot.hasData) {
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : "Other",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                } else {
                                                                                  Map? userDetails = snapshot.data!.snapshot.value as Map?;
                                                                                  // print("userName : $userName");
                                                                                  String userName = userDetails!['UserName'].toString();
                                                                                  // print("userName00011 : $userName");
                                                                                  return Text(
                                                                                    bookedSlotIsYour ? "Your Booking" : userName,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: ConstFontStyle().titleText1,
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                          )),
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
                                                                    flex: 10,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        String
                                                                            targetedSlot =
                                                                            bookSlotController.slotList[timeIndex +
                                                                                1];
                                                                        bool
                                                                            isAbelToSelect =
                                                                            bookSlotController.checkUserAbelToSelectSlot(targetedValue: {
                                                                          courtId:
                                                                              targetedSlot
                                                                        });

                                                                        if (isAbelToSelect) {
                                                                          // print(courtId);
                                                                          bookSlotController
                                                                              .selectedSlotIndex
                                                                              .value = index;
                                                                          bookSlotController.selectedSlotTime =
                                                                              halfHourSlotTime;
                                                                          bookSlotController.selectedCourtId =
                                                                              courtId;
                                                                          bookSlotController.selectedIsCompleted =
                                                                              isCompletedHalfHourSlot;
                                                                          setState(
                                                                              () {});
                                                                        } else {
                                                                          Utils()
                                                                              .snackBar(message: "Slot is not available, please select other slot.");
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
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

                                                        child: Builder(
                                                          builder: (context) {
                                                            if (isSelected) {
                                                              if (isSelectedSlotOneHour) {
                                                                //
                                                                return
                                                                    //   Container(
                                                                    //   height:
                                                                    //   deviceHeight *
                                                                    //       0.09,
                                                                    //   width:
                                                                    //   deviceWidth *
                                                                    //       0.33,
                                                                    //   decoration :
                                                                    //   BoxDecoration(
                                                                    //     // color: ConstColor.highLightBooking,
                                                                    //       borderRadius:
                                                                    //       BorderRadius.circular(5)),
                                                                    //   child: Column(
                                                                    //     mainAxisAlignment:
                                                                    //     MainAxisAlignment
                                                                    //         .center,
                                                                    //     children: [
                                                                    //       Flexible(
                                                                    //         flex:
                                                                    //         10,
                                                                    //         fit: FlexFit
                                                                    //             .tight,
                                                                    //         child:
                                                                    //         GestureDetector(
                                                                    //           onTap:
                                                                    //               () {
                                                                    //             print(slotTime);
                                                                    //             print(courtId);
                                                                    //             bookSlotController.selectedSlotIndex.value =
                                                                    //                 index;
                                                                    //             bookSlotController.selectedSlotTime =
                                                                    //                 slotTime;
                                                                    //             bookSlotController.selectedCourtId =
                                                                    //                 courtId;
                                                                    //             bookSlotController.selectedIsCompleted =
                                                                    //                 isCompletedOneHourSlot;
                                                                    //             setState(() {});
                                                                    //           },
                                                                    //           child: Container(
                                                                    //             decoration: BoxDecoration(
                                                                    //               color: isCompletedOneHourSlot
                                                                    //                   ? ConstColor
                                                                    //                   .greyTextColor
                                                                    //                   : ConstColor
                                                                    //                   .primaryColor,
                                                                    //               borderRadius: BorderRadius.only(
                                                                    //                   topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                    //               ),
                                                                    //             ),
                                                                    //             margin: EdgeInsets.only(top: 5,right: 10,left: 10),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ),
                                                                    //       Flexible(
                                                                    //         flex: 1,
                                                                    //         fit: FlexFit
                                                                    //             .tight,
                                                                    //         child: Container(
                                                                    //             child:
                                                                    //             fullWidthPath),
                                                                    //       ),
                                                                    //       Flexible(
                                                                    //         flex:
                                                                    //         10,
                                                                    //         fit: FlexFit
                                                                    //             .tight,
                                                                    //         child: Container(
                                                                    //           decoration: BoxDecoration(
                                                                    //             color: isCompletedOneHourSlot
                                                                    //                 ? ConstColor
                                                                    //                 .greyTextColor
                                                                    //                 : ConstColor
                                                                    //                 .primaryColor,
                                                                    //             borderRadius: BorderRadius.only(
                                                                    //                 bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)
                                                                    //             ),
                                                                    //           ),
                                                                    //           margin: EdgeInsets.only(bottom: 5,right: 10,left: 10),
                                                                    //         ),
                                                                    //         // GestureDetector(
                                                                    //         //   onTap: () {
                                                                    //         //     String targetedSlot =  bookSlotController.slotList[timeIndex+1];
                                                                    //         //     // // print("halfHourSlotTime : $halfHourSlotTime");
                                                                    //         //     // // print("slotTime : $slotTime");
                                                                    //         //     // print("targetedSlot : $targetedSlot");
                                                                    //         //     // print("courtId : $courtId");
                                                                    //         //     bool isAbelToSelect = bookSlotController.checkUserAbelToSelectSlot(targetedValue: {courtId : targetedSlot});
                                                                    //         //     // print("isAbelToSelect : $isAbelToSelect");
                                                                    //         //
                                                                    //         //     if(isAbelToSelect) {
                                                                    //         //       print(courtId);
                                                                    //         //       bookSlotController.selectedSlotIndex.value =
                                                                    //         //           index;
                                                                    //         //
                                                                    //         //       bookSlotController.selectedSlotTime =
                                                                    //         //           halfHourSlotTime;
                                                                    //         //       bookSlotController.selectedCourtId =
                                                                    //         //           courtId;
                                                                    //         //       bookSlotController.selectedIsCompleted =
                                                                    //         //           isCompletedOneHourSlot;
                                                                    //         //       setState(() {});
                                                                    //         //     } else {
                                                                    //         //       Utils().snackBar(message: "Slot is not available, please select other slot.");
                                                                    //         //     }
                                                                    //         //   },
                                                                    //         //   child:
                                                                    //         //   Container(
                                                                    //         //       // decoration: BoxDecoration(
                                                                    //         //       //     color: isCompletedOneHourSlot
                                                                    //         //       //         ? ConstColor
                                                                    //         //       //         .greyTextColor
                                                                    //         //       //         : ConstColor
                                                                    //         //       //         .primaryColor,
                                                                    //         //       //     borderRadius: BorderRadius.only(
                                                                    //         //       //         topLeft: Radius.circular(5), topRight: Radius.circular(5)
                                                                    //         //       //     ),
                                                                    //         //       //     // borderRadius:
                                                                    //         //       //     // BorderRadius.circular(5)
                                                                    //         //       // ),
                                                                    //         //     margin: EdgeInsets.only(bottom: 5,right: 10,left: 10),
                                                                    //         //   ),
                                                                    //         // ),
                                                                    //       ),
                                                                    //     ],
                                                                    //   ),
                                                                    // );
                                                                    Center(
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        deviceHeight *
                                                                            0.096,
                                                                    width:
                                                                        deviceWidth *
                                                                            0.34,
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
                                                                                .highlightBooking,
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
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // print(slotTime);
                                                                            //
                                                                            // print(courtId);
                                                                            // bookSlotController.selectedSlotIndex.value =
                                                                            //     index;
                                                                            // bookSlotController.selectedSlotTime =
                                                                            //     slotTime;
                                                                            // bookSlotController.selectedCourtId =
                                                                            //     courtId;
                                                                            // bookSlotController.selectedIsCompleted =
                                                                            //     isCompletedOneHourSlot;
                                                                            // setState(() {});
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                deviceWidth * 0.33,
                                                                            height:
                                                                                deviceHeight * 0.043,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: isCompletedOneHourSlot ? ConstColor.greyTextColor : ConstColor.highlightBooking,
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                                                              // BorderRadius.circular(5)
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                              child: Text(
                                                                                bookSlotController.selectedSlotTime.toString(),
                                                                                style: ConstFontStyle().titleText1!.copyWith(fontSize: 11),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Flexible(
                                                                          flex:
                                                                              1,
                                                                          fit: FlexFit
                                                                              .tight,
                                                                          child:
                                                                              Container(child: fullWidthPath),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            String
                                                                                targetedSlot =
                                                                                bookSlotController.slotList[timeIndex + 1];
                                                                            bool
                                                                                isAbelToSelect =
                                                                                bookSlotController.checkUserAbelToSelectSlot(targetedValue: {
                                                                              courtId: targetedSlot
                                                                            });

                                                                            if (isAbelToSelect) {
                                                                              // print(courtId);
                                                                              bookSlotController.selectedSlotIndex.value = index;
                                                                              bookSlotController.selectedSlotTime = halfHourSlotTime;
                                                                              bookSlotController.selectedCourtId = courtId;
                                                                              bookSlotController.selectedIsCompleted = isCompletedHalfHourSlot;
                                                                              setState(() {});
                                                                            } else {
                                                                              Utils().snackBar(message: "Slot is not available, please select other slot.");
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                deviceWidth * 0.33,
                                                                            height:
                                                                                deviceHeight * 0.047,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: isCompletedOneHourSlot ? ConstColor.greyTextColor : ConstColor.highlightBooking,
                                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                                                                              // BorderRadius.circular(5)
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                              child: Text(
                                                                                isCompletedHalfHourSlot ? "Completed" : "Available",
                                                                                // bookSlotController.selectedSlotTime.toString(),
                                                                                style: ConstFontStyle().titleText1,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              } else if (isSelectedSlotHalfHour) {
                                                                if (isSelectedSlotFirstHalf) {
                                                                  //
                                                                  return Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      // border: Border(
                                                                      //   bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                      //   right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                                      // ),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          deviceHeight *
                                                                              0.09,
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      decoration: BoxDecoration(
                                                                          // color: ConstColor.primaryColor,
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Flexible(
                                                                            flex:
                                                                                10,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                // print(slotTime);

                                                                                // print(courtId);
                                                                                bookSlotController.selectedSlotIndex.value = index;
                                                                                bookSlotController.selectedSlotTime = slotTime;
                                                                                bookSlotController.selectedCourtId = courtId;
                                                                                bookSlotController.selectedIsCompleted = isCompletedOneHourSlot;
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                color: Colors.transparent,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                Container(child: fullWidthPath),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                10,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                Container(
                                                                              width: deviceWidth * 0.33,
                                                                              decoration: BoxDecoration(
                                                                                color: isCompletedHalfHourSlot ? ConstColor.greyTextColor : ConstColor.highlightBooking,
                                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                                child: Text(
                                                                                  // "0",
                                                                                  bookSlotController.selectedSlotTime.toString(),
                                                                                  style: ConstFontStyle().titleText1!.copyWith(fontSize: 11),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else if (isSelectedSlotSecondHalf) {
                                                                  //
                                                                  return Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      // border: Border(
                                                                      //   bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                                      //   right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                                      // ),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          deviceHeight *
                                                                              0.09,
                                                                      width: deviceWidth *
                                                                          0.33,
                                                                      decoration: BoxDecoration(
                                                                          // color: ConstColor.primaryColor,
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Flexible(
                                                                            flex:
                                                                                10,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                print("fgf" + slotTime);
                                                                                // print(courtId);
                                                                                bookSlotController.selectedSlotIndex.value = index;
                                                                                bookSlotController.selectedSlotTime = slotTime;
                                                                                bookSlotController.selectedCourtId = courtId;
                                                                                bookSlotController.selectedIsCompleted = isCompletedOneHourSlot;
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                  width: deviceWidth * 0.33,
                                                                                  margin: EdgeInsets.only(bottom: 5),
                                                                                  decoration: BoxDecoration(
                                                                                    color: isCompletedPreviousHalfHourSlot ? ConstColor.greyTextColor : ConstColor.highlightBooking,
                                                                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(top: deviceHeight * 0.01, left: 2),
                                                                                    child: Text(
                                                                                      isCompletedPreviousHalfHourSlot
                                                                                          // isCompletedHalfHourSlot
                                                                                          ? "Completed"
                                                                                          : "Available",
                                                                                      // bookSlotController.selectedSlotTime.toString(),
                                                                                      style: ConstFontStyle().titleText1!.copyWith(fontSize: 14),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                Container(child: fullWidthPath),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                10,
                                                                            fit:
                                                                                FlexFit.tight,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                String targetedSlot = bookSlotController.slotList[timeIndex + 1];
                                                                                bool isAbelToSelect = bookSlotController.checkUserAbelToSelectSlot(targetedValue: {
                                                                                  courtId: targetedSlot
                                                                                });

                                                                                if (isAbelToSelect) {
                                                                                  print(courtId);
                                                                                  bookSlotController.selectedSlotIndex.value = index;
                                                                                  bookSlotController.selectedSlotTime = halfHourSlotTime;
                                                                                  bookSlotController.selectedCourtId = courtId;
                                                                                  bookSlotController.selectedIsCompleted = isCompletedHalfHourSlot;
                                                                                  setState(() {});
                                                                                } else {
                                                                                  Utils().snackBar(message: "Slot is not available, please select other slot.");
                                                                                }
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
                                                                      flex: 10,
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              slotTime);
                                                                          print(
                                                                              courtId);
                                                                          bookSlotController
                                                                              .selectedSlotIndex
                                                                              .value = index;
                                                                          bookSlotController.selectedSlotTime =
                                                                              slotTime;
                                                                          bookSlotController.selectedCourtId =
                                                                              courtId;
                                                                          bookSlotController.selectedIsCompleted =
                                                                              isCompletedOneHourSlot;
                                                                          setState(
                                                                              () {});
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
                                                                      flex: 10,
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              "halfHourSlotTime : $halfHourSlotTime");
                                                                          String
                                                                              targetedSlot =
                                                                              bookSlotController.slotList[timeIndex + 1];
                                                                          // // // print("slotTime : $slotTime");
                                                                          // // print("targetedSlot : $targetedSlot");
                                                                          // // print("courtId : $courtId");
                                                                          bool
                                                                              isAbelToSelect =
                                                                              bookSlotController.checkUserAbelToSelectSlot(targetedValue: {
                                                                            courtId:
                                                                                targetedSlot
                                                                          });
                                                                          // // print("isAbelToSelect : $isAbelToSelect");

                                                                          if (isAbelToSelect) {
                                                                            print(courtId);
                                                                            bookSlotController.selectedSlotIndex.value =
                                                                                index;

                                                                            bookSlotController.selectedSlotTime =
                                                                                halfHourSlotTime;
                                                                            bookSlotController.selectedCourtId =
                                                                                courtId;
                                                                            bookSlotController.selectedIsCompleted =
                                                                                isCompletedHalfHourSlot;
                                                                            setState(() {});
                                                                          } else {
                                                                            Utils().snackBar(message: "Slot is not available, please select other slot.");
                                                                          }
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

                        // print("bookSlotController.bookedSlotTimeList $bookSlotController.bookedSlotTimeList");
                        // bookSlotController.checkSelectedSlotWithIn24Hours();

                        if (await bookSlotController.checkUserNameExist()) {
                          Utils()
                              .snackBar(message: "Please add your name first.");
                          Get.to(() => ProfileScreen());
                        } else {
                          if (bookSlotController.selectedSlotTime == null) {
                            Utils().snackBar(
                                message: "Please select slot for booking.");
                          } else if (bookSlotController.selectedIsCompleted) {
                            Utils().snackBar(
                                message:
                                    "Slot is completed. Please choose available slot.");
                          } else if (!bookSlotController
                              .checkSelectedSlotWithIn24Hours()) {
                            Utils().snackBar(
                                message:
                                    "You can book this slot only 24 hours ago.");
                          } else {
                            bookSlotController.checkUserAbelToBook(
                                context: context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: ConstColor.primaryColor),
                      child: Text(
                        'Book',
                        style: ConstFontStyle().textStyle1,
                      )
                      // Icon(Icons.add, size: 30),
                      ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: deviceHeight * 0.109,
        width: deviceWidth,
        color: ConstColor.btnBackGroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                    onPressed: () {
                      _dateScrollcontroller.animateTo(
                        _dateScrollcontroller.position.minScrollExtent,
                        // selectedDateIndex * 45.0, // Adjust 110 according to your item size and spacing
                        duration: Duration(milliseconds: 1300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                    )),
              ),
              Container(
                width: deviceWidth * 0.75,
                // color: Colors.red,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _dateScrollcontroller,
                  child: Row(
                    children: List.generate(bookSlotController.next7Days.length,
                        (index) {
                      var item = bookSlotController.next7Days[index];
                      // print("index : ${bookSlotController.next7Days[index]}");

                      int date = int.parse(item.day.toString());
                      int currentDate = bookSlotController.currentDate!.day;
                      int previousDate = bookSlotController.currentDate!
                          .subtract(Duration(days: 1))
                          .day;
                      int nextDate = bookSlotController.currentDate!
                          .add(Duration(days: 1))
                          .day;

                      String dateText = currentDate == date
                          ? "Today"
                          : nextDate == date
                              ? "Tmrw"
                              : previousDate == date
                                  ? "Ystr"
                                  : date.toString().padLeft(2, '0');

                      String dayName =
                          DateFormat('EEEE').format(item).substring(0, 3);

                      bool isPastDay =
                          item.isBefore(bookSlotController.currentDate!);
                      print("isPastDay : ${isPastDay}");

                      return currentDate == date || nextDate == date
                          ? StreamBuilder(
                              stream: dbref
                                  .child('User_Bookings')
                                  .orderByChild('date')
                                  .equalTo(item.toString().substring(0, 10))
                                  .onValue,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox();
                                } else {
                                  Map? bookingData =
                                      snapshot.data!.snapshot.value as Map?;

                                  int availableSlot = 30;
                                  int availableSlotFull = 30;

                                  int halfhourSlot = 0;
                                  int onehourSlot = 0;

                                  bool isHalfHours = false;
                                  if (bookingData != null) {
                                    print("bookingData00001 : $bookingData");
                                    DateTime parseTimeString(
                                        String timeString) {
                                      return DateFormat('hh:mm a')
                                          .parse(timeString);
                                    }

                                    bookingData.forEach((key, value) {
                                      print("from: ${value['from']}");
                                      DateTime fromTime =
                                          parseTimeString(value['from']);
                                      if (fromTime.minute == 30) {
                                        print("availableSlot*****" +
                                            availableSlot.toString());
                                        halfhourSlot++;

                                        print("isHalfHours****" +
                                            isHalfHours.toString());
                                      } else {
                                        onehourSlot++;
                                        print("isHalfHours++++" +
                                            isHalfHours.toString());
                                      }
                                    });
                                  }

                                  availableSlot = 30 - (onehourSlot + (halfhourSlot *2)) ;
                                  print('Number of availableSlot : $availableSlot');

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        bookSlotController.selectedDateIndex =
                                            index;
                                        bookSlotController.selectedDate = item;
                                        bookSlotController.selectedSlotTime =
                                            null;
                                        bookSlotController
                                            .selectedSlotIndex.value = -1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: deviceHeight * .09,
                                        width: deviceWidth * 0.17,
                                        decoration: BoxDecoration(
                                          color: bookSlotController
                                                      .selectedDateIndex ==
                                                  index
                                              ? ConstColor.greyTextColor!
                                                  .withOpacity(0.1)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(dateText,
                                                style: index ==
                                                        bookSlotController
                                                            .selectedDateIndex
                                                    ? ConstFontStyle().headline2
                                                    : ConstFontStyle()
                                                        .titleText1),
                                            Text(dayName,
                                                style: ConstFontStyle()
                                                    .mainTextStyle3!
                                                    .copyWith(fontSize: 10)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                  isPastDay
                                                      ? "0 slots"
                                                      : "$availableSlot slots",
                                                  style: index ==
                                                          bookSlotController
                                                              .selectedDateIndex
                                                      ? ConstFontStyle()
                                                          .headline1
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
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: GestureDetector(
                                onTap: () {
                                  bookSlotController.selectedDateIndex = index;
                                  bookSlotController.selectedDate = item;
                                  bookSlotController.selectedSlotTime = null;
                                  bookSlotController.selectedSlotIndex.value =
                                      -1;
                                  setState(() {});
                                },
                                child: Container(
                                  height: deviceHeight * .09,
                                  width: deviceWidth * 0.17,
                                  decoration: BoxDecoration(
                                    color:
                                        bookSlotController.selectedDateIndex ==
                                                index
                                            ? ConstColor.greyTextColor!
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(dateText,
                                          style: index ==
                                                  bookSlotController
                                                      .selectedDateIndex
                                              ? ConstFontStyle().headline2
                                              : ConstFontStyle().titleText1),
                                      Text(dayName,
                                          style: ConstFontStyle()
                                              .mainTextStyle3!
                                              .copyWith(fontSize: 10)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                            isPastDay ? "0 slots" : "30 slots",
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
                    }),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      _dateScrollcontroller.animateTo(
                        _dateScrollcontroller.position.maxScrollExtent,
                        // selectedDateIndex * 45.0, // Adjust 110 according to your item size and spacing
                        duration: Duration(milliseconds: 1300),
                        curve: Curves.easeInOut,
                      );
                      // setState(() {
                      //
                      // });
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    )),
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
      color: ConstColor.backBtnColor,
      child: Container(),
    );
  }
}

// bottomNavigationBar: Container(
//   height: deviceHeight * 0.109,
//   width: deviceWidth,
//   color: ConstColor.btnBackGroundColor,
//   child: Padding(
//     padding: EdgeInsets.symmetric(vertical: 6),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: IconButton(
//               onPressed: () {
//                 _dateScrollcontroller.animateTo(
//                   _dateScrollcontroller.position.minScrollExtent,
//                   // selectedDateIndex * 45.0, // Adjust 110 according to your item size and spacing
//                   duration: Duration(milliseconds: 1300),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               icon: Icon(Icons.arrow_back_ios_new,size: 20,)
//           ),
//         ),
//         Container(
//           width: deviceWidth * 0.75,
//           // color: Colors.red,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             controller: _dateScrollcontroller,
//             child: Row(
//               children: List.generate(bookSlotController.next7Days.length,
//                       (index) {
//                     var item = bookSlotController.next7Days[index];
//                     // print("index : ${bookSlotController.next7Days[index]}");
//
//                     int date = int.parse(item.day.toString());
//                     int currentDate = bookSlotController.currentDate!.day;
//                     int previousDate = bookSlotController.currentDate!.subtract(Duration(days: 1)).day;
//                     int nextDate = bookSlotController.currentDate!.add(Duration(days: 1)).day;
//
//                     String dateText = currentDate == date
//                         ? "Today"
//                         : nextDate == date
//                         ? "Tmrw"
//                         : previousDate == date
//                         ? "Ystr"
//                         :
//                     date.toString().padLeft(2, '0');
//
//                     String dayName =
//                     DateFormat('EEEE').format(item).substring(0, 3);
//
//                     bool isPastDay = item.isBefore(bookSlotController.currentDate!);
//                     print("isPastDay : ${isPastDay}");
//
//                     return currentDate == date || nextDate == date ? StreamBuilder(
//                       stream: dbref.child('User_Bookings').orderByChild('date').equalTo(item.toString().substring(0, 10)).onValue,
//                       builder: (context, snapshot) {
//                         if(!snapshot.hasData) {
//                           return SizedBox();
//                         } else {
//                           Map? bookingData = snapshot.data!.snapshot.value as Map?;
//
//                           int availableSlot = 30;
//
//                           DateTime now = DateTime.now();
//                           int numberOfBookingInFuture = 0;
//
//                           if(bookingData != null) {
//                             print("bookingData00001 : $bookingData");
//                             availableSlot = 30 - bookingData!.length;
//
//                             bookingData!.forEach((key, value) {
//                               print("from : ${value['from']}");
//                               bool isCompleted = DateTime.parse(value['timeStamp']).isAfter(now);
//                               print("isCompleted00001 : $isCompleted");
//                               if(!isCompleted) {
//                                 numberOfBookingInFuture++;
//                               }
//                             });
//                           }
//                           print("numberOfBookingInFuture : $numberOfBookingInFuture");
//
//                           if(currentDate == date || nextDate == date) {
//                             availableSlot = bookSlotController.countFutureSlots(item);
//                             // availableSlot = 10;
//                           } else {
//                             availableSlot = 30;
//                           }
//
//
//                           // print('Number of availableSlot : $availableSlot');
//
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 bookSlotController.selectedDateIndex = index;
//                                 bookSlotController.selectedDate = item;
//                                 bookSlotController.selectedSlotTime = null;
//                                 bookSlotController.selectedSlotIndex.value = -1;
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 height: deviceHeight * .09,
//                                 width: deviceWidth * 0.17,
//
//                                 decoration: BoxDecoration(
//                                   color: bookSlotController.selectedDateIndex == index
//                                       ? ConstColor.greyTextColor!.withOpacity(0.1)
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(dateText,
//                                         style: index ==
//                                             bookSlotController.selectedDateIndex
//                                             ? ConstFontStyle().headline2
//                                             : ConstFontStyle().titleText1),
//                                     Text(dayName,
//                                         style: ConstFontStyle().mainTextStyle3!.copyWith(fontSize: 10)),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.symmetric(vertical: 8.0),
//                                       child: Text(
//                                           isPastDay ? "0 slots" :
//                                           "$availableSlot slots",
//                                           style: index ==
//                                               bookSlotController
//                                                   .selectedDateIndex
//                                               ? ConstFontStyle().headline1
//                                               : ConstFontStyle()
//                                               .titleText1!
//                                               .copyWith(
//                                             fontSize: 12,
//                                           )),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ) : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           bookSlotController.selectedDateIndex = index;
//                           bookSlotController.selectedDate = item;
//                           bookSlotController.selectedSlotTime = null;
//                           bookSlotController.selectedSlotIndex.value = -1;
//                           setState(() {});
//                         },
//                         child: Container(
//                           height: deviceHeight * .09,
//                           width: deviceWidth * 0.17,
//
//                           decoration: BoxDecoration(
//                             color: bookSlotController.selectedDateIndex == index
//                                 ? ConstColor.greyTextColor!.withOpacity(0.1)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(dateText,
//                                   style: index ==
//                                       bookSlotController.selectedDateIndex
//                                       ? ConstFontStyle().headline2
//                                       : ConstFontStyle().titleText1),
//                               Text(dayName,
//                                   style: ConstFontStyle().mainTextStyle3!.copyWith(fontSize: 10)),
//                               Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Text(
//                                     isPastDay ? "0 slots" :
//                                     "30 slots",
//                                     style: index ==
//                                         bookSlotController
//                                             .selectedDateIndex
//                                         ? ConstFontStyle().headline1
//                                         : ConstFontStyle()
//                                         .titleText1!
//                                         .copyWith(
//                                       fontSize: 12,
//                                     )),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//         ),
//         Expanded(
//           child: IconButton(
//               onPressed: () {
//                 _dateScrollcontroller.animateTo(
//                   _dateScrollcontroller.position.maxScrollExtent,
//                   // selectedDateIndex * 45.0, // Adjust 110 according to your item size and spacing
//                   duration: Duration(milliseconds: 1300),
//                   curve: Curves.easeInOut,
//                 );
//                 // setState(() {
//                 //
//                 // });
//               },
//               icon: Icon(Icons.arrow_forward_ios_sharp,size: 20,)
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

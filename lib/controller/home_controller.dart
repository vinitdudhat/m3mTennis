import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/comman/confirmationCard.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/comman/const_fonts.dart';
import 'package:m3m_tennis/repository/common_function.dart';
import 'package:m3m_tennis/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comman/snackbar.dart';
import '../screens/booking/confirmBooking_screen.dart';

class BookSlotController extends GetxController {
  // RxInt selectedSlotIndex = -1.obs;
  RxInt selectedSlotIndex = RxInt(-1);
  String? selectedSlotTime;
  String selectedCourtId = "WC";
  bool selectedIsCompleted = false;

  RxBool isBookingLoading = false.obs;

  List timeList = [6,7,8, 9, 10, 11, 12, 13,14,15,16,17,18,19,20,21,22,23];
  List slotList = [
    "06:00 AM - 07:00 AM",
    "07:00 AM - 08:00 AM",
    "08:00 AM - 09:00 AM",
    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 AM",
    "12:00 AM - 01:00 PM",
    "01:00 PM - 02:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
    "04:00 PM - 05:00 PM",
    "05:00 PM - 06:00 PM",
    "06:00 PM - 07:00 PM",
    "07:00 PM - 08:00 PM",
    "08:00 PM - 09:00 PM",
    "09:00 PM - 10:00 PM",
    "10:00 PM - 11:00 PM",
    // "11:00 PM - 12:00 PM",
  ];
  List bookedSlotTimeList = [];

  String? currentDate;
  DateTime? selectedDate;
  int selectedDateIndex = 0;
  List<DateTime> next7Days = [];

  final _dbRef = FirebaseDatabase.instance.ref('Booking').child("User_Bookings");
  final dbRefUser = FirebaseDatabase.instance.ref('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userName = '';

  confirmBookingSlot(
      {required String courtId, required String date, required String slot}) {
    print(selectedSlotTime);
    List<String> times = selectedSlotTime!.split(" - ");
    String fromTime = times[0];
    String toTime = times[1];

    // print(fromTime);
    // print(toTime);
    // print(auth.currentUser!.displayNAMe.toString());

    String bookingId = uniqueString();
    String currentTime = getCurrentTime();
    print(bookingId);

    _dbRef.child(bookingId).set({
      "BookingId": bookingId,
      "userId": auth.currentUser?.uid,
      "date":
      selectedDate!.toString().substring(0, 10),
      "from": fromTime,
      "to": toTime,
      "courtId": selectedCourtId,
      "createdAt": currentTime,
    });
    Get.back();
    Get.to(() => ConfirmBookingScreen(courtId: courtId, date: date, slot: slot, bookingId: bookingId,userName: userName,));
    Utils().snackBar(message: "Your Booking Is Confirmed");
    selectedSlotTime = null;
    selectedSlotIndex.value = -1;
  }

  Future<bool> checkUserNameExist() async {
    DataSnapshot snapshot = await dbRefUser.child(auth.currentUser!.uid).get();
    Map bookingsData = snapshot.value as Map;

    if(bookingsData['UserName'] == null || bookingsData['UserName'] == '') {

      // print("username001 : ${bookingsData['UserName']}");
      // Utils().snackBar(message: "Please add your name first.");
      // Get.to(() => ProfileScreen());
      return true;
    } else {
      userName = bookingsData['UserName'];
      print("username1 : ${bookingsData['UserName']}");
      return false;
    }
  }

  bool checkSelectedSlotWithIn24Hours() {
    print(selectedSlotTime);
    print(selectedDate);

    List<String> dateComponents = selectedDate!.toString().substring(0, 10).split("-");
    int year = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int day = int.parse(dateComponents[2]);
    List<String> timeParts = selectedSlotTime!.split(' - ');
    String startTime = timeParts[0];
    String fromTime = convertTo24HourFormat(startTime);
    List<String> timeHoursFrom = fromTime.split(':');
    DateTime slotFromTime = DateTime(
      year,
      month,
      day,
      int.parse(timeHoursFrom[0]),
      int.parse(timeHoursFrom[1]),
    );

    DateTime currentTime = DateTime.now();
    DateTime after24Hours = currentTime.add(Duration(hours: 24));

    bool isSelectedSlotWithIn24Hours = after24Hours.isAfter(slotFromTime);
    print("isSelectedSlotWithIn24Hours : $isSelectedSlotWithIn24Hours");

    return isSelectedSlotWithIn24Hours;
  }

  checkUserAbelToBook({required BuildContext context}) async {
    DataSnapshot snapshot = await _dbRef.orderByChild('userId').equalTo(auth.currentUser?.uid).get();
    if(snapshot.value != null) {
      Map bookingsData = snapshot.value as Map;
      print(bookingsData);
      print(bookingsData.length);
      DateTime currentTime = DateTime.now();
      String currentDate = currentTime!.toString().substring(0, 10);
      // print("currentDate : $currentDate");

      bool userAbelToBook = true;

      bookingsData.forEach((key, value) {
        // print("date : ${value['date']}");

        bool isSameDate = currentDate == value['date'];
        // print('Is same date: $isSameDate');

        List<String> dateComponents = value['date'].split("-");
        int year = int.parse(dateComponents[0]);
        int month = int.parse(dateComponents[1]);
        int day = int.parse(dateComponents[2]);
        DateTime firebaseDate = DateTime(year, month, day);
        bool isAfterDate = firebaseDate.isAfter(currentTime);
        // print('isAfter date: $isAfterDate');

        // print("toTime : ${value['to']}");

        if(isAfterDate || isSameDate) {
          print("date : ${value['date']}");
          print("fromTime : ${value['from']}");
          String fromTime = convertTo24HourFormat(value['from']);
          print("fromTime : $fromTime");
          List<String> timeParts = fromTime.split(':');

          DateTime targetTime = DateTime(
            year,
            month,
            day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          bool isAfterTargetTime = currentTime.isAfter(targetTime);
          print('isAfterTargetTime $isAfterTargetTime');

          bool isBookingCompleted = isAfterTargetTime;
          print('isBookingCompleted $isBookingCompleted');

          if (!isBookingCompleted) {
            print('The booking is not complete.');
            userAbelToBook = false;
          }
        }
      });


      if (userAbelToBook) {
        // print('User abel to book');
        // Utils().snackBar(message: "User abel to book.");

        // int courtId = selectedCourtId == 'WC' ? 2 : 1;
        String courtId = selectedCourtId == 'EC' ? "East Court" : "West Court" ;

        DateTime dateTime =
        DateTime.parse(selectedDate!.toString().substring(0, 10));
        String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

        confirmationBottomSheet(
            context: context,
            courtId: courtId,
            slot: selectedSlotTime!,
            date: formattedDate);
      } else {
        Utils().snackBar(message: "You are able to book after your present slot complete.");
        print('User not abel to book now');
      }

    } else {
      print('User abel to book');
      // Utils().snackBar(message: "User abel to book.");

      // int courtId = selectedCourtId == 'WC' ? 2 : 1;
      String courtId = selectedCourtId == 'EC' ? "East Court" : "West Court" ;

      DateTime dateTime =
      DateTime.parse(selectedDate!.toString().substring(0, 10));
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

      confirmationBottomSheet(
          context: context,
          courtId: courtId,
          slot: selectedSlotTime!,
          date: formattedDate);
    }
  }

  bool checkUserAbelToSelectSlot({required Map targetedValue}) {
    bool isContains = bookedSlotTimeList.any((map) => map.toString() == targetedValue.toString());

    if(isContains) {
      return false;
    } else {
      return true;
    }
  }

  // checkUserAbelToSelectSlot({required BuildContext context, String targetedSlot = '10:30 AM - 11:30 AM'}) async {
  //
  //   // final _dbref = FirebaseDatabase.instance.ref().child('_dbRef');
  //   DataSnapshot snapshot = await _dbRef.orderByChild('date').equalTo(selectedDate!.toString().substring(0, 10)).get();
  //
  //   if(snapshot.value != null) {
  //     Map bookingsData = snapshot.value as Map;
  //     print(bookingsData);
  //     print(bookingsData.length);
  //
  //     bool userAbelToSelectSlot = true;
  //
  //     bookingsData.forEach((key, value) {
  //       String slotTime = value['from'] +" - "+ value['to'];
  //       // if(slotTime == ) {
  //       //
  //       //  } else {
  //       //
  //       //  }
  //     });
  //   } else {
  //
  //   }
  // }


  // availableSlot() {
  //   final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  //
  //   databaseReference.child('User_Bookings').orderByChild('date').equalTo('2024-02-08').once().then((DataSnapshot snapshot) {
  //     if (snapshot.value != null) {
  //       // Loop through the retrieved data
  //       snapshot.value!.forEach((key, value) {
  //         print(value); // Output each data entry with date "2024-02-08"
  //       });
  //     } else {
  //       print('No data found with date "2024-02-08"');
  //     }
  //   } as FutureOr Function(DatabaseEvent value)).catchError((error) {
  //     print('Error retrieving data: $error');
  //   });
  // }





  void confirmationBottomSheet(
      {required BuildContext context, required String courtId, required String date, required String slot}) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          )),
      backgroundColor: ConstColor.btnBackGroundColor,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.38,
          decoration: BoxDecoration(
              color: ConstColor.btnBackGroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 25,
                              color: ConstColor.greyTextColor,
                            )),
                        Text("Booking Confirmation",
                            style: ConstFontStyle().mainTextStyle1!.copyWith(
                              fontFamily: ConstFont.popinsMedium,
                            )),
                      ],
                    ),
                  ),
                  CommonConfirmationCard(courtNumber: courtId,date: date,time: slot),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text("Please confirm your tennis court booking for an 1 hour slot.",
                          textAlign: TextAlign.start,
                          style: ConstFontStyle().buttonTextStyle),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Container(
                              height:
                              MediaQuery.of(context).size.height * 0.044,
                              width: MediaQuery.of(context).size.width * 0.27,
                              decoration: BoxDecoration(
                                // color: Color(0xffD6D1D3),
                                  border: Border.all(color: Color(0xffD6D1D3)),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Text('Cancel',
                                    style: ConstFontStyle().mainTextStyle),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Get.to(()=> ConfirmBookingScreen());
                            confirmBookingSlot(courtId: courtId, date: date, slot: slot);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Container(
                              height:
                              MediaQuery.of(context).size.height * 0.044,
                              width: MediaQuery.of(context).size.width * 0.27,
                              decoration: BoxDecoration(
                                  color: ConstColor.primaryColor,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Text('Confirm',
                                    style: ConstFontStyle()
                                        .mainTextStyle!
                                        .copyWith(
                                        color:
                                        ConstColor.btnBackGroundColor)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ); // Replace with your bottom sheet widget
      },
    );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Container(
    //       padding: EdgeInsets.all(16.0),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           ListTile(
    //             leading: Icon(Icons.exit_to_app),
    //             title: Text('Logout'),
    //             onTap: () {
    //               // SharedPreferences prefs = await SharedPreferences.getInstance();
    //               // await prefs.clear();
    //               // Get.offAll(() => LoginScreen());
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }


}
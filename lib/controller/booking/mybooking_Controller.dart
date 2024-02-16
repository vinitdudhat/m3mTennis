
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/comman/snackbar.dart';

import '../../comman/const_fonts.dart';
import 'package:http/http.dart' as http;

class MyBookingController extends GetxController{
  RxInt isActive = 2.obs;
  TextEditingController member1 = TextEditingController();
  TextEditingController member2 = TextEditingController();
  TextEditingController member3 = TextEditingController();

  final dbref = FirebaseDatabase.instance.ref('Booking');
  final FirebaseAuth auth = FirebaseAuth.instance;


  addMemberInBooking({required String bookingId}) {
    Map<String, String> textMap = {};

    if (member1.text.isNotEmpty) {
      textMap['member1'] = member1.text;
    }
    // Add text from TextField 2 to map if not empty
    if (member3.text.isNotEmpty) {
      textMap['member2'] = member2.text;
    }
    // Add text from TextField 3 to map if not empty
    if (member3.text.isNotEmpty) {
      textMap['member3'] = member3.text;
    }

    dbref.child("User_Bookings").child(bookingId).update({
      "memberList" : textMap,
    }).then((value) {
      // Get.back();
      // Get.back();
      Utils().snackBar(message: "Members added successfully");
    });
  }

  void cancelBottomSheet(
      {required BuildContext context,required String bookingId, required String slotTime}) {

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
          height: MediaQuery.of(context).size.height * 0.36,
          decoration: BoxDecoration(
              color: ConstColor.btnBackGroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
                        Text("Booking Cancel",
                            style: ConstFontStyle().mainTextStyle1!.copyWith(
                              fontFamily: ConstFont.popinsMedium,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.11),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text("Do you want to cancel your tennis court booking at $slotTime.",
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
                              height: MediaQuery.of(context).size.height  * 0.044,
                              width: MediaQuery.of(context).size.width * 0.27,
                              decoration: BoxDecoration(
                                  color: ConstColor.btnBackGroundColor,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: Color(0xffD6D1D3))),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: ConstFontStyle().mainTextStyle!.copyWith(color: Color(0xffD6D1D3)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            dbref.child('User_Bookings').child(bookingId).remove().then((_) {
                              print('Your tennis court booking at $slotTime successfully deleted.');
                              Get.back();
                              pushNotificationsAllUsers(title: 'Booking Cancel', body: 'Tennis court booking at $slotTime is available now.');
                              // Utils().snackBar(message: 'Booking with ID $bookingId deleted successfully.');
                            });
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
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {

    String dataNotifications = '{ '
          ' "to" : "/topics/All" , '
          ' "notification" : {'
          ' "title":"$title" , '
          ' "body":"$body" ,'
          ' } '
          ' } ';

    String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
    String fcmKey = 'AAAA8ISTRHE:APA91bGw07E_TbZOAUvgouh33Uv4TvKrSajf0sBXFU5WzOJr6S8LZBNF71FnyBxX8Fjc5Bu82KJisrxW8Wah_b6xdZI7AP9pL_f9nirkyKWK_JTwHsg6bPjeU5GvGUSGs3FeyVjjyWhE';

    var response = await http.post(
      Uri.parse(BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${fcmKey}',
      },
      body: dataNotifications,
    );
    print("Status Code");
    print(response.statusCode);

    if(response.statusCode == 200) {
      Utils().snackBar(message: "Notification sent successfully.");
    } else {
      Utils().snackBar(message: "Please try again");
    }

    return true;
  }

}
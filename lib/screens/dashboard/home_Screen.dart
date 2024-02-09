import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
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
        leading: GestureDetector(
            onTap: () {
              Get.to(() => MyBookingScreen());
            },
            child: Icon(Icons.event_note_sharp,color: ConstColor.greyTextColor,)),
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
                                     // height: deviceHeight
                                     //     // * 0.95,
                                     // * 2,
                                     height: deviceHeight * 1.9,
                                     // height: deviceHeight * 0.7,
                                     width: deviceWidth * 0.2,
                                     // color: Colors.amber,
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
                                         bool isCompleted = false;

                                         DateTime currentTime = DateTime.now();
                                         List<String> dateComponents = bookSlotController.selectedDate!.toString().substring(0, 10).split("-");
                                         int year = int.parse(dateComponents[0]);
                                         int month = int.parse(dateComponents[1]);
                                         int day = int.parse(dateComponents[2]);

                                         List<String> timeParts = slotTime.split(' - ');
                                         String endTime = timeParts[1];
                                         String toTime = convertTo24HourFormat(endTime);
                                         print("toTime000 : $toTime");

                                         List<String> timeHours = toTime.split(':');
                                         DateTime targetTime = DateTime(
                                         year,
                                         month,
                                         day,
                                         int.parse(timeHours[0]),
                                         int.parse(timeHours[1]),
                                         );
                                         isCompleted = currentTime.isAfter(targetTime);


                                         String courtId = index % 2 == 0 ? 'EC'  : 'WC';
                                         bool isPractiseSlot = false;

                                         if(courtId == 'EC') {
                                           // print("length : ${practiseData['EC']['slotList'].length}");
                                           if(practiseData['EC']['slotList'].length != 0) {

                                             for(int i=1; i <= practiseData['EC']['slotList'].length; i++) {
                                               // print("i+++" + i.toString());
                                               var slot = practiseData['EC']['slotList']["slot${i.toString()}"];
                                               // print("sloti+++" + slot.toString());

                                               String isPractiseSlotTime = slot['from'] +" - "+ slot['to'];
                                               // print("isPractiseSlotTime : $isPractiseSlotTime");
                                               // print("slotTime : $slotTime");

                                               bool match = slotTime == isPractiseSlotTime;
                                               if(match) {
                                                 isPractiseSlot = true;
                                               }
                                               // print("isisPractiseSlot : $isPractiseSlot");
                                             }
                                           }
                                         } else {
                                           if(practiseData['WC']['slotList'].length != 0) {
                                             for(int i=1; i <= practiseData['WC']['slotList'].length; i++) {
                                               var slot = practiseData['WC']['slotList']["slot${i.toString()}"];
                                               String isPractiseSlotTime = slot['from'] +" - "+ slot['to'];
                                               bool match = slotTime == isPractiseSlotTime;
                                               if(match) {
                                                 isPractiseSlot = true;
                                               }
                                             }
                                           }
                                         }

                                         if(isPractiseSlot) {
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
                                                     color: ConstColor.childrenBooking,
                                                     borderRadius: BorderRadius.circular(5)
                                                 ),
                                                 child: Center(child: Text(
                                                   // time.toString(),
                                                   "Children",
                                                   style:  ConstFontStyle().titleText1,)),
                                               ),
                                             ),
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

                                                 // Map? bookData = userBookingsData;
                                                 // print("bookData : $bookData");
                                                 bool isBookedSlot = false;
                                                 bool bookedSlotIsYour = false;
                                                 String userId = "";

                                                 if(bookData != null) {
                                                   bookData.forEach((key, value) {
                                                     // print("key : $key");
                                                     // print("value : $value");

                                                     // DateTime currentTime = DateTime.now();
                                                     // print("currentTime0000 : $currentTime");
                                                     //
                                                     // List<String> dateComponents = value['date'].split("-");
                                                     // int year = int.parse(dateComponents[0]);
                                                     // int month = int.parse(dateComponents[1]);
                                                     // int day = int.parse(dateComponents[2]);
                                                     // String toTime = convertTo24HourFormat(value['to']);
                                                     // print("toTime000 : $toTime");
                                                     //
                                                     // List<String> timeParts = toTime.split(':');
                                                     // DateTime targetTime = DateTime(
                                                     //   year,
                                                     //   month,
                                                     //   day,
                                                     //   int.parse(timeParts[0]),
                                                     //   int.parse(timeParts[1]),
                                                     // );
                                                     // isCompleted = currentTime.isAfter(targetTime);
                                                     // print("isCompleted000 : $isCompleted");
                                                     // if() {
                                                     //
                                                     // }

                                                     if(value['courtId'] == courtId) {
                                                       //
                                                       String bookedSlotTime = value['from'] +" - "+ value['to'];
                                                       // print("slotTime $slotTime");
                                                       // print("bookedSlotTime $bookedSlotTime");

                                                       bool match = slotTime == bookedSlotTime;
                                                       print("match $match");
                                                       if(match) {
                                                         userId = value['userId'];
                                                         isBookedSlot = true;
                                                         bookedSlotIsYour = bookSlotController.auth.currentUser?.uid == value['userId'];
                                                       }
                                                     }
                                                   });
                                                   print("isBookedSlot $isBookedSlot");
                                                 }

                                                 return isBookedSlot ?
                                                 Container(
                                                   decoration: BoxDecoration(
                                                     // color: C,
                                                     border: Border(
                                                       bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                       right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                     ),
                                                   ),
                                                   child: Center(
                                                     child:  Container(
                                                       height: deviceHeight * 0.09,
                                                       width: deviceWidth * 0.33,
                                                       padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
                                                       decoration: BoxDecoration(
                                                           color: ConstColor.highLightBooking,
                                                           borderRadius: BorderRadius.circular(5)
                                                       ),
                                                       child: Column(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                         children: [
                                                           Text(isCompleted ? "Completed" : slotTime, style:  ConstFontStyle().titleText1!.copyWith(fontSize: 12,),textAlign:  TextAlign.center),
                                                           SizedBox(height: 3,),
                                                           StreamBuilder(
                                                               stream: bookSlotController.dbRefUser.child(userId.toString()).onValue,
                                                               builder: (context, snapshot) {
                                                                 if(!snapshot.hasData) {
                                                                   return Text(bookedSlotIsYour ? "Your Booking" : "Other" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,);
                                                                 } else {
                                                                   Map? userDetails = snapshot.data!.snapshot.value as Map?;
                                                                   // print("userName : $userName");
                                                                   String userName = userDetails!['UserName'].toString();
                                                                   print("userName : $userName");

                                                                   return Text(bookedSlotIsYour ? "Your Booking" : userName ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,);
                                                                 }
                                                               },
                                                           ),
                                                           // Text(isCompleted ? "Completed" : "" ,textAlign:  TextAlign.center, style:  ConstFontStyle().titleText1,),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 )
                                                     :
                                                 GestureDetector(
                                                   onTap: () {
                                                     print(slotTime);
                                                     print(courtId);
                                                     bookSlotController.selectedSlotIndex.value = index;
                                                     bookSlotController.selectedSlotTime = slotTime ;
                                                     bookSlotController.selectedCourtId = courtId;
                                                     bookSlotController.selectedIsCompleted = isCompleted;
                                                     setState(() {
                                                     });
                                                   },
                                                   child: Container(
                                                     // height: 120,
                                                     // width: 150,
                                                     // padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                     decoration: BoxDecoration(
                                                       // color: Colors.green,
                                                       color: Colors.transparent,
                                                       border: Border(
                                                         bottom: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
                                                         right: BorderSide(width: 1.0, color: ConstColor.lineColor,), // Right border
                                                       ),
                                                       // Border.all(
                                                       //   color:  ConstColor.lineColor,
                                                       //   width: 1,
                                                       //   style: BorderStyle.solid, // Set the border style to solid
                                                       // ),
                                                     ),
                                                     child: bookSlotController.selectedSlotIndex.value != index ?
                                                     SizedBox()
                                                         : Center(
                                                       child:  Container(
                                                         height: deviceHeight * 0.09,
                                                         width: deviceWidth * 0.33,
                                                         padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
                                                         decoration: BoxDecoration(
                                                             color: isCompleted ? ConstColor.greyTextColor : ConstColor.primaryColor,
                                                             borderRadius: BorderRadius.circular(5)
                                                         ),
                                                         child: Column(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                           children: [
                                                             Text(slotTime,style:  ConstFontStyle().titleText1,textAlign:  TextAlign.center),
                                                           ],
                                                         ),
                                                       ),
                                                     ),
                                                   ),
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
                          print("index : ${bookSlotController.next7Days[index]}");

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
                                print("bookingData00001 : $bookingData");

                                int availableSlot = 30;
                                if(bookingData != null) {
                                  availableSlot = 30 - bookingData!.length;
                                }
                                print('Number of availableSlot : $availableSlot');

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

      // bottomNavigationBar: StreamBuilder(
      //   stream: dbref.child('User_Bookings').onValue,
      //   // stream: dbref.child('User_Bookings').orderByChild('date').equalTo('2024-02-10').onValue,
      //   builder: (context, snapshot) {
      //     if(!snapshot.hasData) {
      //       return SizedBox();
      //     } else {
      //       Map? bookingData = snapshot.data!.snapshot.value as Map?;
      //       print("bookingData00001 : $bookingData");
      //
      //       bookingData!.forEach((key, value) {
      //
      //       });
      //
      //       return Container(
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
      //                           return Padding(
      //                             padding: const EdgeInsets.symmetric(horizontal: 5.0),
      //                             child: GestureDetector(
      //                               onTap: () {
      //                                 bookSlotController.selectedDateIndex = index;
      //                                 bookSlotController.selectedDate = item;
      //                                 setState(() {});
      //                               },
      //                               child: Container(
      //                                 height: deviceHeight * .09,
      //                                 width: deviceWidth * 0.2,
      //                                 color: bookSlotController.selectedDateIndex == index
      //                                     ? ConstColor.greyTextColor!.withOpacity(0.1)
      //                                     : Colors.transparent,
      //                                 child: Column(
      //                                   children: [
      //                                     Text(dateText,
      //                                         style: index ==
      //                                             bookSlotController.selectedDateIndex
      //                                             ? ConstFontStyle().headline2
      //                                             : ConstFontStyle().titleText1),
      //                                     Text(dayName,
      //                                         style: ConstFontStyle().mainTextStyle3),
      //                                     Padding(
      //                                       padding:
      //                                       const EdgeInsets.symmetric(vertical: 8.0),
      //                                       child: Text("12 slots",
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
      //       );
      //     }
      //   },
      // ),
    );
  }
}

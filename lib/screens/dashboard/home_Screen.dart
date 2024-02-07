import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/controller/home_controller.dart';
import 'package:m3m_tennis/repository/common_function.dart';
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
      appBar: AppBar(
        title: Text("Book your next play",style: ConstFontStyle().titleText),
        // titleTextStyle :ConstFontStyle.titleText,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
            icon: Icon(Icons.person),
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

             var bookingsData = bookingData!['User_Bookings'];
             print("bookingsData : $bookingsData");

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
                                     height: deviceHeight * 2,
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
                                     color: ConstColor.backGroundColor,
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
                                         SizedBox(width: 10),
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
                                     height: deviceHeight * 1.08,
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
                                       itemCount:  bookSlotController.timeList.length * 2,
                                       itemBuilder: (context, index) {
                                         int timeIndex = index ~/ 2;
                                         var time = bookSlotController.timeList[timeIndex];
                                         String slotTime = convertTo12HourFormat(time).toString().padLeft(2, '0') +" - "+ convertTo12HourFormat(bookSlotController.timeList[timeIndex+1]);
                                         print("slotTime : $slotTime");

                                         String courtId = index % 2 == 0 ? 'EC'  : 'WC';
                                         int practiseBookTime = courtId == 'EC' ? practiseData['EC']['bookTime'] : practiseData['WC']['bookTime'];
                                         bool practiseSlot = practiseBookTime == time ? true : false;


                                         if(practiseSlot) {
                                           return Container(
                                             decoration: BoxDecoration(
                                               color: Colors.transparent,
                                               border: Border(
                                                 top: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
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

                                           // bool isBooked = ;
                                           // Map bookingData =

                                           return GestureDetector(
                                             onTap: () {
                                               print(time);
                                               print(courtId);

                                               bookSlotController.selectedSlotIndex.value = index;
                                               bookSlotController.selectedSlotTime = slotTime ;
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
                                                   top: BorderSide(width: 1.0, color:ConstColor.lineColor,), // Top border
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
                                                   decoration: BoxDecoration(
                                                       color: ConstColor.primaryColor,
                                                       borderRadius: BorderRadius.circular(5)
                                                   ),
                                                   child: Center(child: Text(
                                                       slotTime
                                                     // convertTo12HourFormat(time)
                                                     ,style:  ConstFontStyle().titleText1,)),
                                                 ),
                                               ),
                                             ),
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
                     onPressed: () {
                      bookSlotController.confirmBookingSlot();
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

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                bookSlotController.selectedDateIndex = index;
                                bookSlotController.selectedDate = item;
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
                                      child: Text("12 slots",
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
}

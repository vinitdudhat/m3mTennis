import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:m3m_tennis/comman/constColor.dart';
import 'package:m3m_tennis/comman/constFontStyle.dart';
import 'package:m3m_tennis/comman/const_fonts.dart';
import 'package:m3m_tennis/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => ProfileScreen());
              },
              icon: Icon(Icons.menu),
              color: Colors.white,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("9 am"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      color: ConstColor.selectedColor,
                      child: Column(
                        children: [
                          Text(
                            "7-8",
                            style : TextStyle(
                                color: ConstColor.greyTextColor
                            ),
                          ),
                          Text("User test",style: TextStyle(
                              color: ConstColor.greyTextColor
                          ),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      // color: ConstColor.backGroundColor,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("10 am"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      // color: ConstColor.backGroundColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      color: ConstColor.selectedColor,
                      child: Column(
                        children: [
                          Text(
                            "7-8",
                            style : TextStyle(
                                color: ConstColor.greyTextColor
                            ),
                          ),
                          Text("User test",style: TextStyle(
                              color: ConstColor.greyTextColor
                          ),)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("11 am"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      color: ConstColor.selectedColor,
                      child: Column(
                        children: [
                          Text(
                            "7-8",
                            style : TextStyle(
                                color: ConstColor.greyTextColor
                            ),
                          ),
                          Text("User test",style: TextStyle(
                              color: ConstColor.greyTextColor
                          ),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      // color: ConstColor.backGroundColor,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("12 am"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      color: ConstColor.selectedColor,
                      child: Column(
                        children: [
                          Text(
                            "7-8",
                            style : TextStyle(
                                color: ConstColor.greyTextColor
                            ),
                          ),
                          Text("User test",style: TextStyle(
                              color: ConstColor.greyTextColor
                          ),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      // color: ConstColor.backGroundColor,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("1 am"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      color: ConstColor.selectedColor,
                      child: Column(
                        children: [
                          Text(
                            "7-8",
                            style : TextStyle(
                                color: ConstColor.greyTextColor
                            ),
                          ),
                          Text("User test",style: TextStyle(
                              color: ConstColor.greyTextColor
                          ),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      // color: ConstColor.backGroundColor,
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        )



      // Stack(
      //   alignment: Alignment.topLeft, // Align containers to the top left corner
      //   children: [
      //     Positioned(
      //       top: 0,
      //       left: 0,
      //       child: Container(
      //         width: deviceWidth * 0.15,
      //         height: MediaQuery.of(context).size.height,
      //         child: SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text("6 AM", style: ConstFontStyle().titleText1),
      //               ),
      //               Text("10 AM", style: ConstFontStyle().titleText1),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       top: 0,
      //       left: deviceWidth * 0.15, // Adjust the left position to accommodate the time container
      //       child: Flexible(
      //         child: SingleChildScrollView(
      //           child: Align(
      //             alignment: Alignment.center,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Row(
      //                     children: [
      //                       Container(
      //                         height: 50,
      //                         width: 150,
      //                         color: ConstColor.selectedColor,
      //                       ),
      //                       SizedBox(width: 20,),
      //                       Container(
      //                         height: 50,
      //                         width: 150,
      //                         color: ConstColor.selectedColor
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Row(
      //                     children: [
      //                       Container(
      //                         height: 50,
      //                         width: 150,
      //                         color: Colors.white.withOpacity(0.5),
      //                       ),
      //                       SizedBox(width: 20,),
      //                       Container(
      //                         height: 50,
      //                         width: 150,
      //                         color: Colors.white.withOpacity(0.5),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),


    );
  }
}


/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedTimeSlot = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slots'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Display 12 hrs time on the left-hand side
            Container(
              height: double.infinity,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  12,
                      (index) => GestureDetector(
                    onTap: () {
                      // Handle tap on time slot
                      setState(() {
                        selectedTimeSlot =
                        '${index + 1}:00 ${index < 6 ? 'AM' : 'PM'}';
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: Colors.grey[300],
                      child: Text('${index + 1}:00 ${index < 6 ? 'AM' : 'PM'}'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Display 7 days date and day-wise list
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      DateTime currentDate =
                      DateTime.now().add(Duration(days: index));
                      return GestureDetector(
                        onTap: () {
                          // Handle tap on date
                          // You can add more logic here if needed
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${currentDate.day}/${currentDate.month}'),
                            Text('${_getDayOfWeek(currentDate.weekday)}'),
                          ],
                        ),
                      );
                    },
                  ),
                  // Overlay container on selected time slot
                  if (selectedTimeSlot.isNotEmpty)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Event details for $selectedTimeSlot',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Sun';
      case 2:
        return 'Mon';
      case 3:
        return 'Tue';
      case 4:
        return 'Wed';
      case 5:
        return 'Thu';
      case 6:
        return 'Fri';
      case 7:
        return 'Sat';
      default:
        return '';
    }
  }
}*/

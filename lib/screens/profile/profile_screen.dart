
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m3m_tennis/comman/const_fonts.dart';
import 'package:m3m_tennis/comman/snackbar.dart';
import 'package:m3m_tennis/controller/authentication/login_Controller.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/controller/authentication/profile_controller.dart';
import 'package:m3m_tennis/repository/const_pref_key.dart';
import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
import 'package:m3m_tennis/screens/profile/updateProfile_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comman/constAsset.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';
import '../../comman/constValidation.dart';
import '../booking/bookingCriteria_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  final dbref = FirebaseDatabase.instance.ref('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbrefBooking = FirebaseDatabase.instance.ref('Booking');
  TextEditingController emailController = TextEditingController();

  String? mobileNumber;
  // String? email = '';
  String? userName = '';
  String? profilePhoto;
  String? memberSince;
  String? flatNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPref();
  }

  getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool isNotificationOn = prefs.getBool(SharedPreferenKey.isNotificationOn)!;

    if (isNotificationOn != null) {
      profileController.toggleValue.value = isNotificationOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var userId = auth.currentUser?.uid;
    print("userId+++++++" + userId.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text("Profile", style: ConstFontStyle().titleText),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ConstColor.backBtnColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                logoutBottomSheet(context);
              },
              icon: Icon(
                Icons.logout,
                color: ConstColor.backBtnColor,
              ))
        ],
      ),
      backgroundColor: ConstColor.backGroundColor,
      body: StreamBuilder(
        stream: dbref.child(userId.toString()).onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Map? userDetails = snapshot.data!.snapshot.value as Map?;
            print(userDetails);

            mobileNumber = userDetails?['MobileNo'];
            print("mobileNumber : $mobileNumber");
            emailController.text =
            userDetails!['Email'] == '' || userDetails!['Email'] == null
                ? ''
                : userDetails!['Email'];
            userName = userDetails['UserName'];
            if (userName == "") {
              userName = null;
            }

            DateTime dateTime = DateTime.parse(userDetails['createdAt']);
            memberSince = DateFormat('MMM yyyy').format(dateTime);
            flatNumber = userDetails['FlatNo'];

            if (userDetails['ProfilePic'] != null) {
              profilePhoto = userDetails['ProfilePic'].toString();
            }

            return Obx(
                  () => SingleChildScrollView(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.only(top: deviceHeight * 0.02),
                    //   child: Center(
                    //     child: Stack(
                    //       alignment: Alignment.bottomRight,
                    //       children: [
                    //         // Container(
                    //         // padding:
                    //       //     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //         //   child: CircleAvatar(
                    //         //     backgroundColor: Colors.transparent,
                    //         //     radius: 65,
                    //         //     child: ClipOval(
                    //         //         child: profilePhoto == null
                    //         //             ? Image.asset(ConstAsset.avatar)
                    //         //             : Image.network(profilePhoto.toString(),fit: BoxFit.fill,)),
                    //         //   ),
                    //         // ),
                    //         // Positioned(
                    //         //   left: 55,
                    //         //   child: GestureDetector(
                    //         //     onTap: () {
                    //         //     },
                    //         //     child: Center(
                    //         //       child: Icon(
                    //         //         Icons.verified,
                    //         //         color: ConstColor.primaryColor,
                    //         //       ),
                    //         //     ),
                    //         //   ),
                    //         // )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: profilePhoto != null
                                  ? Image(
                                image: NetworkImage(profilePhoto!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null)
                                    return child;
                                  return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child:
                                          CircularProgressIndicator()));
                                },
                              )
                                  : Image.asset(
                                ConstAsset.avatar,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            child: GestureDetector(
                              onTap: () {},
                              child: Center(
                                child: Icon(
                                  Icons.verified,
                                  color: ConstColor.primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName ?? "M3M Tennis",
                            style: ConstFontStyle().mainTextStyle2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => UpdateProfileScreen(
                                userName: userName == null ? "" : userName!,
                                flat: flatNumber == null ? "" : flatNumber!,
                                profileImage: profilePhoto,
                                mobile: mobileNumber == null
                                    ? ""
                                    : mobileNumber,
                              ));
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              color: ConstColor.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Flat #${flatNumber == null ? 1234 : flatNumber}",
                      style: ConstFontStyle()
                          .mainTextStyle
                          .copyWith(color: ConstColor.greyTextColor),
                    ),
                    StreamBuilder(
                      stream: dbrefBooking
                          .child('User_Bookings')
                          .orderByChild('userId')
                          .equalTo(userId.toString())
                          .onValue,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          Map? bookData = snapshot.data!.snapshot.value as Map?;
                          print("bookData : $bookData");

                          int totalBooking = 0;
                          if (bookData != null) {
                            totalBooking = bookData!.length;
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.02,
                                vertical: deviceHeight * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      totalBooking.toString(),
                                      style: ConstFontStyle()
                                          .mainTextStyle
                                          .copyWith(
                                          color: ConstColor.greyTextColor),
                                    ),
                                    Text(
                                      "Bookings",
                                      style: ConstFontStyle().mainTextStyle3,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: deviceWidth * 0.02),
                                  child: Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: ConstColor.greyTextColor),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${totalBooking} hrs",
                                      style: ConstFontStyle()
                                          .mainTextStyle
                                          .copyWith(
                                          color: ConstColor.greyTextColor),
                                    ),
                                    Text(
                                      "Played",
                                      style: ConstFontStyle().mainTextStyle3,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: deviceWidth * 0.02),
                                  child: Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: ConstColor.greyTextColor),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      memberSince!.toString(),
                                      // "Jun 2023",
                                      style: ConstFontStyle()
                                          .mainTextStyle
                                          .copyWith(
                                          color: ConstColor.greyTextColor),
                                    ),
                                    Text(
                                      "Member Since",
                                      style: ConstFontStyle().mainTextStyle3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Visibility(
                      visible: mobileNumber != null,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: deviceWidth * 0.04,
                                left: deviceWidth * 0.04,
                                top: deviceHeight * 0.02,
                                bottom: deviceWidth * 0.015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: ConstFontStyle()
                                      .mainTextStyle
                                      .copyWith(
                                      color: ConstColor.greyTextColor),
                                ),
                                Text(
                                  mobileNumber ?? "",
                                  style: ConstFontStyle()
                                      .mainTextStyle
                                      .copyWith(
                                      color: ConstColor.greyTextColor),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.04),
                            child: Divider(
                              color: ConstColor.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Visibility(
                    //   visible: email != null,
                    //   child:

                    Column(
                      children: [
                        /*Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.03,
                              vertical: deviceHeight * 0.01),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: ConstColor.greyTextColor),
                            onChanged: (value) {
                              var userId = auth.currentUser?.uid;
                              final _dbref = FirebaseDatabase.instance
                                  .ref()
                                  .child('Users')
                                  .child(userId.toString());
                              _dbref
                                  .update({
                                    'Email': emailController.text,
                                  })
                                  .then((value) {})
                                  .onError((error, stackTrace) {});
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter Email',
                                labelStyle: ConstFontStyle()
                                    .lableTextStyle
                                    .copyWith(color: ConstColor.greyTextColor),
                                hintStyle: ConstFontStyle()
                                    .lableTextStyle
                                    .copyWith(color: ConstColor.greyTextColor),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0), // Adjust vertical padding
                                alignLabelWithHint: true,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ConstColor.greyTextColor,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: ConstColor.greyTextColor,
                                )),
                          ),
                        ),*/
                        Padding(
                          padding: EdgeInsets.only(
                              right: deviceWidth * 0.04,
                              left: deviceWidth * 0.04,
                              top: deviceHeight * 0.03,
                              bottom: deviceWidth * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: ConstFontStyle()
                                    .mainTextStyle
                                    .copyWith(color: ConstColor.greyTextColor),
                              ),
                              Row(
                                children: [
                                  Text(
                                    emailController.text ??
                                        "m3mtennis@gmail.com",
                                    style: ConstFontStyle()
                                        .mainTextStyle
                                        .copyWith(
                                        color: ConstColor.greyTextColor),
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.02,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        showCustomDialog(context);
                                      },
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: ConstColor.primaryColor,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.04),
                          child: Divider(
                            color: ConstColor.greyTextColor,
                          ),
                        ),
                      ],
                    ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: deviceWidth * 0.04,
                          left: deviceWidth * 0.04,
                          top: deviceHeight * 0.03,
                          bottom: deviceWidth * 0.015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notification",
                            style: ConstFontStyle()
                                .mainTextStyle
                                .copyWith(color: ConstColor.greyTextColor),
                          ),
                          Switch(
                            value: profileController.toggleValue.value,
                            activeColor: ConstColor.primaryColor,
                            onChanged: (value) async {
                              print(value);
                              profileController.toggleValue.value = value;
                              final prefs =
                              await SharedPreferences.getInstance();
                              prefs.setBool(
                                  SharedPreferenKey.isNotificationOn, value);

                              if (value) {
                                FirebaseMessaging.instance
                                    .subscribeToTopic("All");
                              } else {
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("All");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                      child: Divider(
                        color: ConstColor.greyTextColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: deviceWidth * 0.04,
                          left: deviceWidth * 0.04,
                          top: deviceHeight * 0.03,
                          bottom: deviceWidth * 0.015),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => BookingCriteriaScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Booking Criteria",
                              style: ConstFontStyle()
                                  .mainTextStyle
                                  .copyWith(color: ConstColor.greyTextColor),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ConstColor.greyTextColor,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                      child: Divider(
                        color: ConstColor.greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void showCustomDialog(context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: deviceHeight * 0.23,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.003),
            decoration: BoxDecoration(
              color: ConstColor.backGroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.02,right: deviceWidth * 0.02),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close,color: ConstColor.greyTextColor,)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.01),
                  child: TextFormField(
                    controller: emailController,
                    style: TextStyle(color: ConstColor.greyTextColor),
                    decoration: InputDecoration(
                        hintText: 'Enter Email',
                        labelStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        hintStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0),
                        alignLabelWithHint: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ConstColor.greyTextColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ConstColor.greyTextColor,
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.02),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (emailController.text.isEmpty) {
                        Utils().snackBar(message: "Please enter email");
                      } else if (!constValidation()
                          .validateEmail(emailController.text)) {
                        Utils().snackBar(message: "Please enter valid email");
                      } else {
                        Navigator.pop(context);
                        var userId = auth.currentUser?.uid;
                        final _dbref = FirebaseDatabase.instance
                            .ref()
                            .child('Users')
                            .child(userId.toString());
                        _dbref
                            .update({
                          'Email': emailController.text,
                        })
                            .then((value) {})
                            .onError((error, stackTrace) {});
                        Utils().snackBar(message: "Email Address is Updated.");
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: deviceHeight * 0.05,
                      width: deviceWidth * 0.3,
                      decoration: BoxDecoration(
                          color: ConstColor.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                            "Update",
                            style: ConstFontStyle().mainTextStyle.copyWith(
                              color: ConstColor.black,
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void logoutBottomSheet(BuildContext context) {
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
          height: MediaQuery.of(context).size.height * 0.33,
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
                        Text("Confirmation",
                            style: ConstFontStyle().mainTextStyle1!.copyWith(
                              fontFamily: ConstFont.popinsMedium,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.135),
                    child: Text("Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: ConstFontStyle().buttonTextStyle),
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
                                color: ConstColor.btnBackGroundColor,
                                  border: Border.all(color: Colors.white30),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Text('Cancel',
                                    style: ConstFontStyle().mainTextStyle.copyWith(
                                      color: ConstColor.greyTextColor
                                    )),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.signOut().then((value) async {
                              print('User logged out');
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              await prefs.clear();
                              Get.offAll(() => LoginScreen());
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
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:m3m_tennis/comman/const_fonts.dart';
// import 'package:m3m_tennis/controller/authentication/login_Controller.dart';
// import 'package:get/get.dart';
// import 'package:m3m_tennis/controller/authentication/profile_controller.dart';
// import 'package:m3m_tennis/repository/const_pref_key.dart';
// import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
// import 'package:m3m_tennis/screens/profile/updateProfile_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../comman/constAsset.dart';
// import '../../comman/constColor.dart';
// import '../../comman/constFontStyle.dart';
// import '../booking/bookingCriteria_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   ProfileController profileController = Get.put(ProfileController());
//   final dbref = FirebaseDatabase.instance.ref('Users');
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final dbrefBooking = FirebaseDatabase.instance.ref('Booking');
//   TextEditingController email = TextEditingController();
//
//   String? mobileNumber;
//   // String? email = '';
//   String? userName = '';
//   String? profilePhoto;
//   String? memberSince;
//   String? flatNumber;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getSharedPref();
//   }
//
//   getSharedPref() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool isNotificationOn = prefs.getBool(SharedPreferenKey.isNotificationOn)!;
//
//     if (isNotificationOn != null) {
//       profileController.toggleValue.value = isNotificationOn;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var deviceHeight = MediaQuery.of(context).size.height;
//     var deviceWidth = MediaQuery.of(context).size.width;
//     var userId = auth.currentUser?.uid;
//     print("userId+++++++" + userId.toString());
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ConstColor.backGroundColor,
//         title: Text("Profile", style: ConstFontStyle().titleText),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: ConstColor.backBtnColor,
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 logoutBottomSheet(context);
//               },
//               icon: Icon(
//                 Icons.logout,
//                 color: ConstColor.backBtnColor,
//               ))
//         ],
//       ),
//       backgroundColor: ConstColor.backGroundColor,
//       body: StreamBuilder(
//         stream: dbref.child(userId.toString()).onValue,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             Map? userDetails = snapshot.data!.snapshot.value as Map?;
//             print(userDetails);
//
//             mobileNumber = userDetails?['MobileNo'];
//             print("mobileNumber : $mobileNumber");
//             email.text =
//                 userDetails!['Email'] == '' || userDetails!['Email'] == null
//                     ? ''
//                     : userDetails!['Email'];
//             userName = userDetails['UserName'];
//             if (userName == "") {
//               userName = null;
//             }
//
//             DateTime dateTime = DateTime.parse(userDetails['createdAt']);
//             memberSince = DateFormat('MMM yyyy').format(dateTime);
//             flatNumber = userDetails['FlatNo'];
//
//             if (userDetails['ProfilePic'] != null) {
//               profilePhoto = userDetails['ProfilePic'].toString();
//             }
//
//             return Obx(
//               () => SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Padding(
//                     //   padding: EdgeInsets.only(top: deviceHeight * 0.02),
//                     //   child: Center(
//                     //     child: Stack(
//                     //       alignment: Alignment.bottomRight,
//                     //       children: [
//                     //         // Container(
//                     //         // padding:
//                     //       //     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     //         //   child: CircleAvatar(
//                     //         //     backgroundColor: Colors.transparent,
//                     //         //     radius: 65,
//                     //         //     child: ClipOval(
//                     //         //         child: profilePhoto == null
//                     //         //             ? Image.asset(ConstAsset.avatar)
//                     //         //             : Image.network(profilePhoto.toString(),fit: BoxFit.fill,)),
//                     //         //   ),
//                     //         // ),
//                     //         // Positioned(
//                     //         //   left: 55,
//                     //         //   child: GestureDetector(
//                     //         //     onTap: () {
//                     //         //     },
//                     //         //     child: Center(
//                     //         //       child: Icon(
//                     //         //         Icons.verified,
//                     //         //         color: ConstColor.primaryColor,
//                     //         //       ),
//                     //         //     ),
//                     //         //   ),
//                     //         // )
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Stack(
//                         alignment: Alignment.bottomRight,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 shape: BoxShape.circle),
//                             child: ClipOval(
//                               child: profilePhoto != null
//                                   ? Image(
//                                       image: NetworkImage(profilePhoto!),
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.cover,
//                                       loadingBuilder:
//                                           (context, child, loadingProgress) {
//                                         if (loadingProgress == null)
//                                           return child;
//                                         return Container(
//                                             width: 100,
//                                             height: 100,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.grey,
//                                                 shape: BoxShape.circle),
//                                             child: Center(
//                                                 child:
//                                                     CircularProgressIndicator()));
//                                       },
//                                     )
//                                   : Image.asset(
//                                       ConstAsset.avatar,
//                                       width: 100,
//                                       height: 100,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 50,
//                             child: GestureDetector(
//                               onTap: () {},
//                               child: Center(
//                                 child: Icon(
//                                   Icons.verified,
//                                   color: ConstColor.primaryColor,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     Padding(
//                       padding: EdgeInsets.only(top: deviceHeight * 0.015),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             userName ?? "M3M Tennis",
//                             style: ConstFontStyle().mainTextStyle2,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Get.to(() => UpdateProfileScreen(
//                                     userName: userName == null ? "" : userName!,
//                                     flat: flatNumber == null ? "" : flatNumber!,
//                                     profileImage: profilePhoto,
//                                     mobile: mobileNumber == null
//                                         ? ""
//                                         : mobileNumber,
//                                   ));
//                             },
//                             child: Icon(
//                               Icons.edit_outlined,
//                               color: ConstColor.primaryColor,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Text(
//                       "Flat #${flatNumber == null ? 1234 : flatNumber}",
//                       style: ConstFontStyle()
//                           .mainTextStyle
//                           .copyWith(color: ConstColor.greyTextColor),
//                     ),
//                     StreamBuilder(
//                       stream: dbrefBooking
//                           .child('User_Bookings')
//                           .orderByChild('userId')
//                           .equalTo(userId.toString())
//                           .onValue,
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return Container();
//                         } else {
//                           Map? bookData = snapshot.data!.snapshot.value as Map?;
//                           print("bookData : $bookData");
//
//                           int totalBooking = 0;
//                           if (bookData != null) {
//                             totalBooking = bookData!.length;
//                           }
//
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: deviceWidth * 0.02,
//                                 vertical: deviceHeight * 0.04),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text(
//                                       totalBooking.toString(),
//                                       style: ConstFontStyle()
//                                           .mainTextStyle
//                                           .copyWith(
//                                               color: ConstColor.greyTextColor),
//                                     ),
//                                     Text(
//                                       "Bookings",
//                                       style: ConstFontStyle().mainTextStyle3,
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: deviceWidth * 0.02),
//                                   child: Text(
//                                     "|",
//                                     style: TextStyle(
//                                         fontSize: 30,
//                                         color: ConstColor.greyTextColor),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       "${totalBooking} hrs",
//                                       style: ConstFontStyle()
//                                           .mainTextStyle
//                                           .copyWith(
//                                               color: ConstColor.greyTextColor),
//                                     ),
//                                     Text(
//                                       "Played",
//                                       style: ConstFontStyle().mainTextStyle3,
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: deviceWidth * 0.02),
//                                   child: Text(
//                                     "|",
//                                     style: TextStyle(
//                                         fontSize: 30,
//                                         color: ConstColor.greyTextColor),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       memberSince!.toString(),
//                                       // "Jun 2023",
//                                       style: ConstFontStyle()
//                                           .mainTextStyle
//                                           .copyWith(
//                                               color: ConstColor.greyTextColor),
//                                     ),
//                                     Text(
//                                       "Member Since",
//                                       style: ConstFontStyle().mainTextStyle3,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     Visibility(
//                       visible: mobileNumber != null,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 right: deviceWidth * 0.04,
//                                 left: deviceWidth * 0.04,
//                                 top: deviceHeight * 0.02,
//                                 bottom: deviceWidth * 0.015),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Phone Number",
//                                   style: ConstFontStyle()
//                                       .mainTextStyle
//                                       .copyWith(
//                                           color: ConstColor.greyTextColor),
//                                 ),
//                                 Text(
//                                   mobileNumber ?? "",
//                                   style: ConstFontStyle()
//                                       .mainTextStyle
//                                       .copyWith(
//                                           color: ConstColor.greyTextColor),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: deviceWidth * 0.04),
//                             child: Divider(
//                               color: ConstColor.greyTextColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Visibility(
//                     //   visible: email != null,
//                     //   child:
//
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: deviceWidth * 0.03,
//                               vertical: deviceHeight * 0.01),
//                           child: TextFormField(
//                             controller: email,
//                             style: TextStyle(color: ConstColor.greyTextColor),
//                             onChanged: (value) {
//                               var userId = auth.currentUser?.uid;
//                               final _dbref = FirebaseDatabase.instance
//                                   .ref()
//                                   .child('Users')
//                                   .child(userId.toString());
//                               _dbref
//                                   .update({
//                                     'Email': email.text,
//                                   })
//                                   .then((value) {})
//                                   .onError((error, stackTrace) {});
//                             },
//                             decoration: InputDecoration(
//                                 hintText: 'Enter Email',
//                                 labelStyle: ConstFontStyle()
//                                     .lableTextStyle
//                                     .copyWith(color: ConstColor.greyTextColor),
//                                 hintStyle: ConstFontStyle()
//                                     .lableTextStyle
//                                     .copyWith(color: ConstColor.greyTextColor),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 10.0), // Adjust vertical padding
//                                 alignLabelWithHint: true,
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: ConstColor.greyTextColor,
//                                   ),
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.email_outlined,
//                                   color: ConstColor.greyTextColor,
//                                 )),
//                           ),
//                         ),
//                         // Padding(
//                         //   padding: EdgeInsets.only(
//                         //       right: deviceWidth * 0.04,
//                         //       left: deviceWidth * 0.04,
//                         //       top: deviceHeight * 0.03,
//                         //       bottom: deviceWidth * 0.015),
//                         //   child: Row(
//                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //     children: [
//                         //       Text(
//                         //         "Email",
//                         //         style: ConstFontStyle()
//                         //             .mainTextStyle
//                         //             .copyWith(color: ConstColor.greyTextColor),
//                         //       ),
//                         //       Text(
//                         //         email ?? "m3mtennis@gmail.com",
//                         //         style: ConstFontStyle()
//                         //             .mainTextStyle
//                         //             .copyWith(color: ConstColor.greyTextColor),
//                         //       )
//                         //     ],
//                         //   ),
//                         // ),
//                         // Padding(
//                         //   padding: EdgeInsets.symmetric(
//                         //       horizontal: deviceWidth * 0.04),
//                         //   child: Divider(
//                         //     color: ConstColor.greyTextColor,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                     // ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           right: deviceWidth * 0.04,
//                           left: deviceWidth * 0.04,
//                           top: deviceHeight * 0.03,
//                           bottom: deviceWidth * 0.015),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Notification",
//                             style: ConstFontStyle()
//                                 .mainTextStyle
//                                 .copyWith(color: ConstColor.greyTextColor),
//                           ),
//                           Switch(
//                             value: profileController.toggleValue.value,
//                             activeColor: ConstColor.primaryColor,
//                             onChanged: (value) async {
//                               print(value);
//                               // setState(() {
//
//                               profileController.toggleValue.value = value;
//                               final prefs =
//                                   await SharedPreferences.getInstance();
//                               prefs.setBool(
//                                   SharedPreferenKey.isNotificationOn, value);
//
//                               if (value) {
//                                 FirebaseMessaging.instance
//                                     .subscribeToTopic("All");
//                               } else {
//                                 FirebaseMessaging.instance
//                                     .unsubscribeFromTopic("All");
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
//                       child: Divider(
//                         color: ConstColor.greyTextColor,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           right: deviceWidth * 0.04,
//                           left: deviceWidth * 0.04,
//                           top: deviceHeight * 0.03,
//                           bottom: deviceWidth * 0.015),
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.to(() => BookingCriteriaScreen());
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Booking Criteria",
//                               style: ConstFontStyle()
//                                   .mainTextStyle
//                                   .copyWith(color: ConstColor.greyTextColor),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: ConstColor.greyTextColor,
//                               size: 20,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
//                       child: Divider(
//                         color: ConstColor.greyTextColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   void logoutBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       // isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//         top: Radius.circular(15),
//       )),
//       backgroundColor: ConstColor.btnBackGroundColor,
//       builder: (BuildContext context) {
//         return Container(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.33,
//           decoration: BoxDecoration(
//               color: ConstColor.btnBackGroundColor,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(15),
//               )),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).size.height * 0.015),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               Get.back();
//                             },
//                             icon: Icon(
//                               Icons.close,
//                               size: 25,
//                               color: ConstColor.greyTextColor,
//                             )),
//                         Text("Confirmation",
//                             style: ConstFontStyle().mainTextStyle1!.copyWith(
//                                   fontFamily: ConstFont.popinsMedium,
//                                 )),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).size.height * 0.135),
//                     child: Text("Are you sure you want to logout?",
//                         textAlign: TextAlign.center,
//                         style: ConstFontStyle().buttonTextStyle),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).size.height * 0.02),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25)),
//                             child: Container(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.044,
//                               width: MediaQuery.of(context).size.width * 0.27,
//                               decoration: BoxDecoration(
//                                   // color: Color(0xffD6D1D3),
//                                   border: Border.all(color: Color(0xffD6D1D3)),
//                                   borderRadius: BorderRadius.circular(25)),
//                               child: Center(
//                                 child: Text('Cancel',
//                                     style: ConstFontStyle().mainTextStyle),
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             FirebaseAuth auth = FirebaseAuth.instance;
//                             await auth.signOut().then((value) async {
//                               print('User logged out');
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               await prefs.clear();
//                               Get.offAll(() => LoginScreen());
//                             });
//                           },
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25)),
//                             child: Container(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.044,
//                               width: MediaQuery.of(context).size.width * 0.27,
//                               decoration: BoxDecoration(
//                                   color: ConstColor.primaryColor,
//                                   borderRadius: BorderRadius.circular(25)),
//                               child: Center(
//                                 child: Text('Confirm',
//                                     style: ConstFontStyle()
//                                         .mainTextStyle!
//                                         .copyWith(
//                                             color:
//                                                 ConstColor.btnBackGroundColor)),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ); // Replace with your bottom sheet widget
//       },
//     );
//     // showModalBottomSheet(
//     //   context: context,
//     //   builder: (BuildContext context) {
//     //     return Container(
//     //       padding: EdgeInsets.all(16.0),
//     //       child: Column(
//     //         mainAxisSize: MainAxisSize.min,
//     //         children: <Widget>[
//     //           ListTile(
//     //             leading: Icon(Icons.exit_to_app),
//     //             title: Text('Logout'),
//     //             onTap: () {
//     //               // SharedPreferences prefs = await SharedPreferences.getInstance();
//     //               // await prefs.clear();
//     //               // Get.offAll(() => LoginScreen());
//     //               Navigator.pop(context);
//     //             },
//     //           ),
//     //         ],
//     //       ),
//     //     );
//     //   },
//     // );
//   }
// }

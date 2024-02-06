import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../comman/constAsset.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dbref = FirebaseDatabase.instance.ref('Users');
  String? mobileNumber;

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text("Profile",style : ConstFontStyle().titleText),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios,color: ConstColor.backBtnColor,),
        ),
        actions: [
          IconButton(onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // FirebaseAuth auth = FirebaseAuth.instance;
            // await auth.signOut().then((value) async {
            //   print('User logged out');
            //   await prefs.clear();
            //   Get.offAll(() => LoginScreen());
            // });

            await prefs.clear();
            Get.offAll(() => LoginScreen());
          }, icon: Icon(Icons.logout,color: ConstColor.backBtnColor,))
        ],
      ),
      backgroundColor: ConstColor.backGroundColor,
      body: StreamBuilder(
        stream: dbref.child("85f96a47-a6bc-4aa9-acc5-6b77179a6fea").onValue,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          } else {
            Map? userDetails = snapshot.data!.snapshot.value as Map?;
            print(userDetails);

            mobileNumber = userDetails!['Mobileo'].toString();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.02),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: CircleAvatar(
                            backgroundColor: ConstColor.primaryColor,
                            radius: 65,
                            child: ClipOval(
                                child: Image.asset(ConstAsset.avatar)),
                          ),
                        ),
                        Positioned(
                          left: 55,
                          child: GestureDetector(
                            onTap: () {
                            },
                            child: Center(
                              child: Icon(Icons.verified,color: ConstColor.primaryColor,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Aditi Sharma",style: ConstFontStyle().mainTextStyle2,),
                      Icon(Icons.edit_outlined,color: ConstColor.primaryColor,)
                    ],
                  ),
                ),
                Text("Flat #3789",style: ConstFontStyle().mainTextStyle.copyWith(
                    color: ConstColor.greyTextColor
                ),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02,vertical: deviceHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("36",style: ConstFontStyle().mainTextStyle.copyWith(
                              color: ConstColor.greyTextColor
                          ),),
                          Text("Bookings",style: ConstFontStyle().mainTextStyle3,),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                        child: Text("|",style: TextStyle(
                            fontSize: 30,
                            color: ConstColor.greyTextColor
                        ),),
                      ),
                      Column(
                        children: [
                          Text("36 hrs",style: ConstFontStyle().mainTextStyle.copyWith(
                              color: ConstColor.greyTextColor
                          ),),
                          Text("Played",style: ConstFontStyle().mainTextStyle3,),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                        child: Text("|",style: TextStyle(
                            fontSize: 30,
                            color: ConstColor.greyTextColor
                        ),),
                      ),
                      Column(
                        children: [
                          Text("Jun 2023",style: ConstFontStyle().mainTextStyle.copyWith(
                              color: ConstColor.greyTextColor
                          ),),
                          Text("Member Since",style: ConstFontStyle().mainTextStyle3,),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: deviceWidth * 0.04,left : deviceWidth * 0.04,top: deviceHeight * 0.02,bottom: deviceWidth * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phone Number",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),),
                      Text(mobileNumber ?? "",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                  child: Divider(color: ConstColor.greyTextColor,),
                ),

                Padding(
                  padding: EdgeInsets.only(right: deviceWidth * 0.04,left : deviceWidth * 0.04,top: deviceHeight * 0.03,bottom: deviceWidth * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),),
                      Text("aditi@gmail.com",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                  child: Divider(color: ConstColor.greyTextColor,),
                ),

                Padding(
                  padding: EdgeInsets.only(right: deviceWidth * 0.04,left : deviceWidth * 0.04,top: deviceHeight * 0.03,bottom: deviceWidth * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notification",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                  child: Divider(color: ConstColor.greyTextColor,),
                ),

                Padding(
                  padding: EdgeInsets.only(right: deviceWidth * 0.04,left : deviceWidth * 0.04,top: deviceHeight * 0.03,bottom: deviceWidth * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Booking Criteria",style: ConstFontStyle().mainTextStyle.copyWith(
                          color: ConstColor.greyTextColor
                      ),),
                      Icon(Icons.arrow_forward_ios,color: ConstColor.greyTextColor,size: 20,)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                  child: Divider(color: ConstColor.greyTextColor,),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

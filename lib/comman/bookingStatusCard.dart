import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constColor.dart';
import 'constFontStyle.dart';

class BookingStatusCard extends StatefulWidget {
  String courtNo;
  String cDate;
  String cTime;
  // String inviteMember;
  List inviteMemberList;
  List inviteMemberKeyList;
  String bookingId;
  String bookingDate;
  bool isUpcoming;
  final VoidCallback? onTap;

  BookingStatusCard(
      {super.key,
      required this.courtNo,
      required this.cDate,
      required this.cTime,
      required this.inviteMemberList,
      required this.inviteMemberKeyList,
      required this.bookingId,
      required this.bookingDate, this.isUpcoming = false,    this.onTap,

      });

  @override
  State<BookingStatusCard> createState() => _BookingStatusCardState();
}

class _BookingStatusCardState extends State<BookingStatusCard> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Card(
      color: ConstColor.cardBackGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: ConstColor.borderColor)),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
            hasIcon: true,
            iconSize: 35,
            iconColor: ConstColor.greyTextColor,
            fadeCurve: Curves.slowMiddle,
            iconPadding: EdgeInsets.only(
                top: deviceHeight * 0.02, right: deviceWidth * 0.02)),
        header: Padding(
          padding: EdgeInsets.only(
              right: deviceWidth * 0.03,
              left: deviceWidth * 0.03,
              top: deviceWidth * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.courtNo,
                style: ConstFontStyle().mainTextStyle1,
              ),
              Column(
                children: [
                  Text(widget.cDate,
                      style: ConstFontStyle()
                          .mainTextStyle
                          .copyWith(color: ConstColor.greyTextColor)),
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight * 0.01),
                    child: Container(
                      height: deviceHeight * 0.03,
                      // width: deviceWidth * 0.25,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ConstColor.primaryColor)),
                      child: Center(
                        child: Text(widget.cTime,
                            style: ConstFontStyle()
                                .mainTextStyle
                                .copyWith(color: ConstColor.primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        collapsed: const Text(
          "",
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        expanded: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: ConstColor.greyTextColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "You can invite up to 3 members",
                  softWrap: true,
                  style: ConstFontStyle().mainTextStyle.copyWith(
                      fontWeight: FontWeight.w200,
                      color: ConstColor.greyTextColor),
                ),
              ),

              widget.inviteMemberList.length == 0 ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "0 Member",
                  softWrap: true,
                  style: ConstFontStyle().mainTextStyle.copyWith(
                      fontWeight: FontWeight.w200,
                      color: ConstColor.greyTextColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  : Container(
                height: widget.isUpcoming ? deviceHeight * 0.06 * widget.inviteMemberList.length : deviceHeight * 0.03 * widget.inviteMemberList.length,
                width: deviceWidth,
                child: ListView.builder(
                  itemCount: widget.inviteMemberList.length,
                  itemBuilder: (context, index) {
                    String key = widget.inviteMemberKeyList[index];
                    print("key : $key");
                    String name = widget.inviteMemberList[index];
                    print("name : $name");
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  // color: Colors.amber,
                                  width: widget.isUpcoming ? deviceWidth * 0.64 : deviceWidth * 0.8,
                                  child: Text(
                                    name,
                                    // "user user user user user user v useruseruseruseruseruser",
                                    // widget.inviteMemberList['member1'],
                                    softWrap: true,
                                    style: ConstFontStyle().buttonTextStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              widget.isUpcoming ? TextButton(
                                onPressed: () {
                                  final dbref = FirebaseDatabase.instance.ref('Booking');
                                  dbref.child('User_Bookings').child(widget.bookingId).child('memberList').child(key).remove().then((_) {
                                    print('Member remove successfully.');
                                  });
                                }, child: Text(
                                "Remove",
                                softWrap: true,
                                style: ConstFontStyle().highlight1,
                              ),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                              )  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.01),
                child: Divider(
                  color: ConstColor.greyTextColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BOOKING ID",
                          style: ConstFontStyle()
                              .mainTextStyle3
                              .copyWith(fontWeight: FontWeight.w200),
                        ),
                        Text(
                          widget.bookingId,
                          style: ConstFontStyle()
                              .mainTextStyle
                              .copyWith(color: ConstColor.greyTextColor),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BOOKED ON",
                          style: ConstFontStyle()
                              .mainTextStyle3
                              .copyWith(fontWeight: FontWeight.w200),
                        ),
                        Text(
                          widget.bookingDate,
                          style: ConstFontStyle()
                              .mainTextStyle
                              .copyWith(color: ConstColor.greyTextColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.isUpcoming ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Cancel Booking",
                      style: ConstFontStyle()
                          .highlight1,
                    ),
                  ),
                ],
              ) : SizedBox.shrink(),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

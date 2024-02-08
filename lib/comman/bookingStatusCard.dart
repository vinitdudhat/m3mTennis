import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'constColor.dart';
import 'constFontStyle.dart';

class BookingStatusCard extends StatefulWidget {
  String courtNo;
  String cDate;
  String cTime;
  String inviteMember;
  String bookingId;
  String bookingDate;
  BookingStatusCard(
      {super.key,
      required this.courtNo,
      required this.cDate,
      required this.cTime,
      required this.inviteMember,
      required this.bookingId,
      required this.bookingDate});

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
              Text(
                "Invite Member",
                softWrap: true,
                style: ConstFontStyle().mainTextStyle.copyWith(
                    fontWeight: FontWeight.w200,
                    color: ConstColor.greyTextColor),
              ),
              Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.03),
                child: Text(
                 widget.inviteMember,
                  softWrap: true,
                  style: ConstFontStyle().buttonTextStyle,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

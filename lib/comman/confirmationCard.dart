import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m3m_tennis/repository/common_function.dart';

import 'constColor.dart';
import 'constFontStyle.dart';

class CommonConfirmationCard extends StatefulWidget {
  String courtNumber;
  String date;
  String time;
  CommonConfirmationCard({super.key,required this.courtNumber,required this.date , required this.time, });

  @override
  State<CommonConfirmationCard> createState() => _CommonConfirmationCardState();
}

class _CommonConfirmationCardState extends State<CommonConfirmationCard> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: ConstColor.btnBackGroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white30
        )
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03,
              vertical: deviceWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.courtNumber,
                style: ConstFontStyle().mainTextStyle1,
              ),
              Column(
                children: [
                  Text(widget.date,
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
                          border: Border.all(
                              color: ConstColor.primaryColor)),
                      child: Center(
                        child: Text(
                            convertToShowingTimeRange( widget.time),
                            // widget.time,
                            style: ConstFontStyle()
                                .mainTextStyle
                                .copyWith(
                                color:  ConstColor.primaryColor)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}

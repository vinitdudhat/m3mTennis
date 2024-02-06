import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../comman/constColor.dart';
import '../comman/constFontStyle.dart';

class RoundButtonWithIcon extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? loading;
  final String image;

  RoundButtonWithIcon(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.75,
        decoration: BoxDecoration(
            color: ConstColor.btnBackGroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ConstColor.greyTextColor)),
        child: Center(
          child: loading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.0),
                  child: ListTile(
                    leading: SvgPicture.asset(image),
                    title: Text(
                      title,
                      style: ConstFontStyle().buttonTextStyle,
                    ),
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // children: [
                    //   SvgPicture.asset(image),
                    //   Text(
                    //     title,
                    //     style: ConstFontStyle().buttonTextStyle,
                    //   ),
                    // ],
                  ),
                ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? loading;

  RoundButton(
      {super.key, required this.title, required this.onTap, this.loading});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.75,
        decoration: BoxDecoration(
          color: ConstColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: loading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Center(
                child: Text(
                  title,
                  style: ConstFontStyle().mainTextStyle.copyWith(
                    color: ConstColor.black,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

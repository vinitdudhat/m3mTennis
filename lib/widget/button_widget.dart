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

// Widget commonProfileImageCircle({
//   required BuildContext context,
//   required bool isProfileImageLoading,
//   required bool isProfileExist,
//   required String? image,
//   double radius = 17,
// }) {
//   return CircleAvatar(
//     radius: radius,
//     backgroundColor: Colors.transparent,
//     child: ClipOval(
//       child: isProfileImageLoading
//           ? Shimmer.fromColors(
//         // ignore: sort_child_properties_las t
//         child: CircleAvatar(
//             radius: 18, backgroundColor: Colors.grey),
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[400]!,
//       )
//           :
//       isProfileExist
//           ? CachedNetworkImage(
//         imageUrl: image.toString(),
//         fit: BoxFit.fill,
//         errorWidget: (__, _, ___) =>   Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage( AppAssets.studentImg,),
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         // Image.asset(
//         //   AppAssets.collageImg,
//         //   fit: BoxFit.cover,
//         //   width: double.maxFinite,
//         // ),
//         imageBuilder: (context, imageProvider) =>
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//         placeholder: (context, url) =>
//             Shimmer.fromColors(
//               // ignore: sort_child_properties_last
//               child: CircleAvatar(
//                   radius: 18,
//                   backgroundColor: Colors.grey),
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[400]!,
//             ),
//       )
//       // Image.network(getProfileController.networkProfileImage.toString(),fit: BoxFit.fill)
//           :
//       // Container(
//       //   decoration: BoxDecoration(
//       //     image: DecorationImage(
//       //       image: AssetImage( AppAssets.studentImg,),
//       //       fit: BoxFit.fill,
//       //     ),
//       //   ),
//       // ),
//       Image.asset(
//         AppAssets.studentImg,
//         fit: BoxFit.cover,
//         // height: 35,
//       ),
//     ),
//   );
// }

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

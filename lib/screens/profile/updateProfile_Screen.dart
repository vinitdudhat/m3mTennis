import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3m_tennis/comman/constAsset.dart';
import 'package:m3m_tennis/controller/authentication/profile_controller.dart';
import 'package:m3m_tennis/widget/button_widget.dart';
import '../../comman/constColor.dart';
import '../../comman/constFontStyle.dart';
import '../../comman/snackbar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdateProfileScreen extends StatefulWidget {
  final String userName;
  final String flat;
  final String? profileImage;
  final String? mobile;
  // final String? email;
  UpdateProfileScreen(
      {super.key,
      required this.userName,
      required this.flat,
      required this.profileImage,
      required this.mobile,
      // required this.email
      });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController username = TextEditingController();
  TextEditingController flat = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  File? imageNotes;
  String selectedItemNotes = "Camera";
  final GlobalKey<FormState> formKey = GlobalKey();
  String? netProfileImage;
  bool isProfileImageUpdate = false;
  String type = '';

  @override
  void initState() {
    username.text = widget.userName;
    flat.text = widget.flat;
    netProfileImage = widget.profileImage;
    mobile.text = widget.mobile!;
    // email.text = widget.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ConstColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: ConstColor.backGroundColor,
        title: Text("Edit Profile", style: ConstFontStyle().titleText),
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.02, vertical: deviceHeight * 0.02),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle),
                        child:  ClipOval(
                          child: isProfileImageUpdate
                              ? Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child:
                                  CircularProgressIndicator()))
                              : netProfileImage != null
                              ? Image(
                            image: NetworkImage(netProfileImage!),
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null)
                                return child;
                              return Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child:
                                      CircularProgressIndicator()));
                            },
                          )
                              : Image.asset(
                            ConstAsset.avatar,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      Positioned(
                        // top: ,
                        left: deviceWidth * 0.14,
                        child: GestureDetector(
                          onTap: () {
                            showDailog(context);
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: ConstColor.white,
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                color: ConstColor.primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: deviceHeight * 0.02),
                //   child: Center(
                //     child: Stack(
                //       alignment: Alignment.bottomRight,
                //       children: [
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //               horizontal: 10, vertical: 13),
                //           child: CircleAvatar(
                //             radius: 55,
                //             backgroundColor: isProfileImageUpdate
                //                 ? ConstColor.greyTextColor
                //                 : Colors.transparent,
                //             child: ClipOval(
                //               child: isProfileImageUpdate
                //                   ? Center(child: CircularProgressIndicator())
                //                   : netProfileImage != null
                //                       ? Image.network(
                //                           netProfileImage!,
                //                         )
                //                       : Image.asset(ConstAsset.avatar),
                //             ),
                //           ),
                //         ),
                //         Positioned(
                //           left: deviceWidth * 0.14,
                //           child: GestureDetector(
                //             onTap: () {
                //               showDailog(context);
                //             },
                //             child: CircleAvatar(
                //               radius: 15,
                //               backgroundColor: ConstColor.white,
                //               child: Center(
                //                 child: Icon(
                //                   Icons.edit,
                //                   color: ConstColor.primaryColor,
                //                   size: 20,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
                  child: TextFormField(
                    controller: username,
                    style: TextStyle(color: ConstColor.greyTextColor),
                    decoration: InputDecoration(
                        hintText: 'Enter name',
                        labelStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        hintStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0), // Adjust vertical padding
                        alignLabelWithHint: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ConstColor.greyTextColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: ConstColor.greyTextColor,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your name";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.01),
                  child: TextFormField(
                    controller: flat,
                    style: TextStyle(color: ConstColor.greyTextColor),
                    decoration: InputDecoration(
                        hintText: 'Enter flat no.',
                        labelStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        hintStyle: ConstFontStyle()
                            .lableTextStyle
                            .copyWith(color: ConstColor.greyTextColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0), // Adjust vertical padding
                        alignLabelWithHint: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ConstColor.greyTextColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.apartment,
                          color: ConstColor.greyTextColor,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Flat No.";
                      }
                    },
                  ),
                ),

                widget.mobile == ""
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.03,
                            vertical: deviceHeight * 0.01),
                        child: TextFormField(
                          controller: mobile,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: TextStyle(color: ConstColor.greyTextColor),
                          decoration: InputDecoration(
                              hintText: 'Enter Mobile No.',
                              labelStyle: ConstFontStyle()
                                  .lableTextStyle
                                  .copyWith(color: ConstColor.greyTextColor),
                              hintStyle: ConstFontStyle()
                                  .lableTextStyle
                                  .copyWith(color: ConstColor.greyTextColor),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0), // Adjust vertical padding
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ConstColor.greyTextColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.phone_android_rounded,
                                color: ConstColor.greyTextColor,
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Mobile No.";
                            }
                          },
                        ),
                      )
                    : SizedBox(),

                // widget.email == "" ?
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: deviceWidth * 0.03,
                //       vertical: deviceHeight * 0.01),
                //   child: TextFormField(
                //     controller: email,
                //     style: TextStyle(color: ConstColor.greyTextColor),
                //     decoration: InputDecoration(
                //         hintText: 'Enter Email',
                //         labelStyle: ConstFontStyle()
                //             .lableTextStyle
                //             .copyWith(color: ConstColor.greyTextColor),
                //         hintStyle: ConstFontStyle()
                //             .lableTextStyle
                //             .copyWith(color: ConstColor.greyTextColor),
                //         contentPadding: EdgeInsets.symmetric(
                //             vertical: 15.0), // Adjust vertical padding
                //         alignLabelWithHint: true,
                //         focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(
                //             color: ConstColor.greyTextColor,
                //           ),
                //         ),
                //         prefixIcon: Icon(
                //           Icons.email_outlined,
                //           color: ConstColor.greyTextColor,
                //         )),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return "Please enter your Email";
                //       }
                //     },
                //   ),
                // ) /*:SizedBox()*/,
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.03),
                  child: RoundButton(
                      title: "Save",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          updateProfileDetails(username.text, flat.text,
                              // mobile.text, email.text
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateProfileDetails(
    String name,
    String flatno,
    // String mobile,
    // String email,
  ) {
    var userId = auth.currentUser?.uid;
    final _dbref =
        FirebaseDatabase.instance.ref().child('Users').child(userId.toString());

    _dbref.update({
      'UserName': name,
      'FlatNo': flatno,
      // 'MobileNo': mobile,
      // 'Email': email,
    }).then((value) {
      Get.back();
      Utils().snackBar(message: "Profile details updated successfully");
    }).onError((error, stackTrace) {
      print("error in update profile");
      Utils().snackBar(message: "Please try again to update your details.");
    });
  }

  Future getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      updateProfileImage(imageNotes!);
      debugPrint(imageNotes.toString());
    });
  }

  Future getImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      updateProfileImage(imageNotes!);
      debugPrint(imageNotes.toString());
    });
  }

  bool validateImgeSize(File imageFile) {
    if (isImageSizeValid(imageFile, maxSizeInBytes: 2 * 1024 * 1024)) {
      return true;
    } else {
      Utils().snackBar(
          message:
              "The selected image size exceeds the maximum allowed size of 2 MB.");
      return false;
    }
  }

  bool isImageSizeValid(File imageFile, {required int maxSizeInBytes}) {
    // Check if the file exists
    if (imageFile.existsSync()) {
      // Obtain the file size in bytes
      int fileSizeInBytes = imageFile.lengthSync();

      // Compare the file size with the specified maximum size
      if (fileSizeInBytes <= maxSizeInBytes) {
        return true; // Image size is valid
      }
    }

    return false; // Image size exceeds the limit
  }

  updateProfileImage(File image) async {
    var userId = auth.currentUser?.uid;
    final _dbref =
        FirebaseDatabase.instance.ref().child('Users').child(userId.toString());

    if (image != null) {
      // bool isValidImageSize = validateImgeSize(image!);

      // if (isValidImageSize) {
      setState(() {
        isProfileImageUpdate = true;
      });

      File profileImage = image!;
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref('/Users/${userId}');
      firebase_storage.UploadTask uploadeTask =
          storageRef.putFile(profileImage!);
      print("uploadeTask : $uploadeTask");

      Future.value(uploadeTask).then((value) async {
        var newUrl = await storageRef.getDownloadURL();

        _dbref.update({
          'ProfilePic': newUrl,
        }).then((value) {
          // Get.back();
          setState(() {
            netProfileImage = newUrl.toString();
            isProfileImageUpdate = false;
          });
          Utils().snackBar(message: "Updated successfully");
        }).onError((error, stackTrace) {
          setState(() {
            isProfileImageUpdate = false;
          });
          print("error in update profile");
          Utils().snackBar(message: "Error in Update Profile");
        });
      }).onError((error, stackTrace) {
        Utils().snackBar(
          message: "Profile not updated",
        );
        setState(() {
          isProfileImageUpdate = false;
        });
      });
      // }
    }
  }

  void showDailog(context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Container(
            height: deviceHeight * 0.18,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: ListTile(
                    title: const Text("Camera"),
                    onTap: () {
                      Navigator.pop(context);
                      getImageCamera();
                    },
                    leading: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Gallery"),
                    onTap: () {
                      Navigator.pop(context);
                      getImageGallery();
                    },
                    leading: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../comman/constColor.dart';
import '../comman/constFontStyle.dart';

class CommonTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obSecure;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onEditingCompleted;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isMulti;
  final bool autofocus;
  final bool enabled;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final String prefix;
  List<TextInputFormatter>? inputFormatters = [];

  CommonTextfield({
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.obSecure,
    this.onTap,
    this.isMulti = false,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.hintText,
    this.suffixIcon,
    required this.prefix,
    this.enabled = true,
    this.onEditingCompleted,
    this.onChanged,
    this.onSaved,
    required this.labelText,
    this.inputFormatters,
    this.onFieldSubmitted,
  });

  @override
  State<CommonTextfield> createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return TextFormField(
      style: TextStyle(
        color: ConstColor.greyTextColor
      ),
      autofocus: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingCompleted,
      obscureText: widget.obSecure,
      minLines: widget.isMulti ? 4 : 1,
      maxLines: widget.isMulti ? null : 1,
      onTap: widget.onTap,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        labelStyle: ConstFontStyle().lableTextStyle.copyWith(
          color: ConstColor.greyTextColor
        ),
        hintStyle: ConstFontStyle().lableTextStyle.copyWith(
            color: ConstColor.greyTextColor
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Adjust vertical padding
        alignLabelWithHint: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ConstColor.greyTextColor,
          ),
        ),
        // errorBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(color: Colors.errorColor, width: 0.5),
        //   borderRadius: BorderRadius.circular(25),
        // ),
        prefixIcon: SizedBox(
            height: deviceHeight * 0.02,width: deviceWidth * 0.02,
            child: SvgPicture.asset(widget.prefix)),
        suffixIcon: widget.suffixIcon,

      ),

      cursorColor: ConstColor.primaryColor,
      validator: widget.validator,
    );
  }
}



class InviteField extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obSecure;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onEditingCompleted;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isMulti;
  final bool autofocus;
  final bool enabled;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  List<TextInputFormatter>? inputFormatters = [];

   InviteField({
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.obSecure,
    this.onTap,
    this.isMulti = false,
    this.readOnly = false,
    this.autofocus = false,
    this.errorText,
    this.hintText,
    this.suffix,
     this.prefix,
    this.enabled = true,
    this.onEditingCompleted,
    this.onChanged,
    this.onSaved,
     this.labelText,
    this.inputFormatters,
    this.onFieldSubmitted,
  });

  @override
  State<InviteField> createState() => _InviteFieldState();
}

class _InviteFieldState extends State<InviteField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return TextFormField(
      autofocus: false,
      style: TextStyle(
        color: ConstColor.greyTextColor
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingCompleted,
      obscureText: widget.obSecure,
      minLines: widget.isMulti ? 4 : 1,
      maxLines: widget.isMulti ? null : 1,
      onTap: widget.onTap,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 11,horizontal: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: ConstColor.cardBackGroundColor,
        labelText: widget.labelText,
        labelStyle: ConstFontStyle().buttonTextStyle,
        errorMaxLines: 2,
        hintText: widget.hintText,
        hintStyle: ConstFontStyle().buttonTextStyle!.copyWith(fontWeight: FontWeight.w400,color: ConstColor.greyTextColor!.withOpacity(0.5)),
        errorText: widget.errorText,
        prefixIcon: widget.prefix,
        suffix: widget.suffix,
        // hintStyle: ConstStyle().hintTextStyle,
      ),
      validator: widget.validator,
    );
  }
}
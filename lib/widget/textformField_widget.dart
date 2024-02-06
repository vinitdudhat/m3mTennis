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
        labelStyle: ConstFontStyle().lableTextStyle,
        hintStyle: ConstFontStyle().lableTextStyle,
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
        suffixIcon: widget.suffixIcon
      ),
      cursorColor: ConstColor.primaryColor,
      validator: widget.validator,
    );
  }
}


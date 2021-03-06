import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyInput extends StatelessWidget {
  final double height;
  final double width;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;
  final Function cb;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool enabled;
  final Function tap;
  final TextEditingController controller;
  MyInput({
    this.height,
    this.width = double.infinity,
    this.fontSize = 30,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius,
    this.text,
    this.obscureText = false,
    this.cb,
    this.tap,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.enabled = true,
    this.controller
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        onTap: tap,
        enabled: enabled,
        maxLines: maxLines,
        autofocus: false,
        style: TextStyle(color: textColor),
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: text,
          contentPadding: EdgeInsets.all(20.w),
          hintStyle: TextStyle(
              color: textColor
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
        onChanged: (value){
          this.cb(value);
        },
      ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 2.w,
                    color: Color(0xFFdedede)
                )
            )
        )
    );
  }
}

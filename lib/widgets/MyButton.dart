import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  @override
  final double height;
  final double width;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius borderRadius;
  final String text;
  final Object cb;
  MyButton({
    this.height,
    this.width,
    this.fontSize = 30,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius,
    this.text,
    this.cb
  });
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize
              ),
            )
          ],
        ),
      ),
      onTap: widget.cb,
    );
  }
}

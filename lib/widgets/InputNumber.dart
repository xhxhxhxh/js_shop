import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bus/eventBus.dart';

class InputNumber extends StatefulWidget {
  final int defaultNumber;
  final int min;
  final Map data;
  InputNumber({this.defaultNumber = 0, this.min = 0, this.data});
  @override
  _InputNumberState createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  int number;
  int min;
  Map data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.number = widget.defaultNumber;
    this.min = widget.min;
    this.data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 45.w,
      child: Row(
        children: [
          InkWell(
            child: Container(
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: Color(0xFFdedede))),
              child: Center(
                child: Text('-'),
              ),
            ),
            onTap: () {
              setState(() {
                if (number > min) {
                  number--;
                  eventBus.fire(ChangeNum(number, data));
                }
              });
            },
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.w, color: Color(0xFFdedede)),
                      bottom: BorderSide(width: 1.w, color: Color(0xFFdedede))
                    )),
                child: Text(number.toString()),
              )
          ),
          InkWell(
              child: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.w, color: Color(0xFFdedede))),
                child: Center(
                  child: Text('+'),
                ),
              ),
              onTap: () {
                setState(() {
                  number++;
                  eventBus.fire(ChangeNum(number, data));
                });
              })
        ],
      ),
    );
  }
}

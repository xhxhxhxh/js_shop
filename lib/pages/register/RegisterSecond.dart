import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSecond extends StatefulWidget {
  final Map arguments;
  RegisterSecond({this.arguments});
  @override
  _RegisterSecondState createState() => _RegisterSecondState();
}

class _RegisterSecondState extends State<RegisterSecond> {
  String verificationCode;
  String phoneNum;
  String inputCode;
  int limitTime = 10;
  int timeOut;
  bool showResend = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationCode = widget.arguments['code'];
    phoneNum = widget.arguments['phoneNum'];
    timeOut = limitTime;
    this._setTimeOut();
  }

  _resendVerificationCode() async{
    var res = await dio.post('/api/sendCode', data: {'tel': this.phoneNum});
    setState(() {
      this.showResend = false;
    });
    this._setTimeOut();
    Map data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      verificationCode = data['code'];
    }
    Fluttertoast.showToast(
      msg: data['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
    );
  }

  _setTimeOut() {
    Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        timeOut--;
        if (timeOut == 0) {
          timeOut = limitTime;
          showResend = true;
          timer.cancel();
        }
        print(timeOut);
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('注册'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.w),
        child: ListView(
          children: [
            Stack(
                alignment: AlignmentDirectional.topCenter,
              children: [
                MyInput(
                    height: 60.w,
                    backgroundColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textColor: Color(0xFF737373),
                    text: '请输入验证码',
                    cb: (value) {
                      this.inputCode = value;
                    }),
                Positioned(
                  right: 0,
                    child: MyButton(
                  text: showResend ? '发送验证码' : '重新发送(${this.timeOut})',
                  width: 190.w,
                  height: 75.w,
                  backgroundColor: Color(0xFFdedede),
                  textColor: Colors.black87,
                  borderRadius: BorderRadius.circular(10.w),
                  fontSize: 30.sp,
                  cb: () {
                    if (this.showResend) {
                      this._resendVerificationCode();
                    }
                  },
                ))
              ],
            ),
            SizedBox(
              height: 75.w,
            ),
            MyButton(
              text: '下一步',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                if (verificationCode == inputCode) {
                  Navigator.pushNamed(context, '/registerThird', arguments: {'code': verificationCode, 'phoneNum': this.phoneNum});
                } else {
                  Fluttertoast.showToast(
                    msg: '验证码不正确',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                }
//                Navigator.pushNamed(context, '/registerThird');
              },
            )
          ],
        ),
      ),
    );
  }
}

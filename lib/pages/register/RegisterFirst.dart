import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/dio.dart';
import '../../config/config.dart';

class RegisterFirst extends StatefulWidget {
  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends State<RegisterFirst> {
  String phoneNum = '';

  _getVerificationCode() async{
    var res = await dio.post('/api/sendCode', data: {'tel': this.phoneNum});
    Map data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      Navigator.pushNamed(context, '/registerSecond', arguments: {'code': data['code'], 'phoneNum': this.phoneNum});
    }
    Fluttertoast.showToast(
      msg: data['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
    );
//    print(result);
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
            MyInput(
                height: 60.w,
                keyboardType: TextInputType.number,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请输入手机号',
                cb: (value){
                  this.phoneNum = value;
                }
            ),
            SizedBox(height: 75.w,),
            MyButton(
              text: '下一步',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                RegExp mobile = new RegExp(r"^1\d{10}$");
                if (mobile.hasMatch(this.phoneNum)) {
                  this._getVerificationCode();
                } else {
                  Fluttertoast.showToast(
                    msg: "手机号格式不正确",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

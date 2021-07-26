import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: Text('登录'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.w),
        child: ListView(
          children: [
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请输入用户名',
                cb: (){}
            ),
            SizedBox(height: 20.w,),
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请输入密码',
                obscureText: true,
                cb: (){}
            ),
            SizedBox(height: 40.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Text('忘记密码', style: TextStyle(color: Color(0xFF202020), fontSize: 30.sp),),
                ),
                InkWell(
                  child: Text('新用户注册', style: TextStyle(color: Color(0xFF202020), fontSize: 30.sp)),
                )
              ],
            ),
            SizedBox(height: 75.w,),
            MyButton(
              text: '登录',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                Navigator.pushNamed(context, '/registerFirst');
              },
            )
          ],
        ),
      ),
    );
  }
}

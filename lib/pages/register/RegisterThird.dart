import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';

class RegisterThird extends StatefulWidget {
  @override
  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends State<RegisterThird> {
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
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请输入密码',
                obscureText: true,
                cb: (){}
            ),
            SizedBox(height: 20.w,),
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请再次输入密码',
                obscureText: true,
                cb: (){}
            ),
            SizedBox(height: 75.w,),
            MyButton(
              text: '完成注册并登录',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
//                Navigator.pushNamed(context, '/registerSecond');
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/Toast.dart';
import 'package:provider/provider.dart';
import '../../provider/userInfo.dart';
import '../../api/Storage.dart';
import 'dart:convert';
import '../../pages/Tabs/Tabs.dart';
import '../../api/dio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNum = '';
  String password = '';

  _login() async {
    var res = await dio.post('/api/doLogin', data: {
      'username': this.phoneNum,
      'password': this.password,
    });

    Map data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      await Storage().setStorage('userInfo', json.encode(data['userinfo']));
      await context.read<UserInfoProvider>().init();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Tabs()),
              (route) => route == null);
    }
    MyToast.show(data['message']);
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
                keyboardType: TextInputType.number,
                text: '请输入用户名',
                cb: (value){
                  this.phoneNum = value;
                }
            ),
            SizedBox(height: 20.w,),
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请输入密码',
                obscureText: true,
                cb: (value){
                  this.password = value;
                }
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
                  onTap: () {
                    Navigator.pushNamed(context, '/registerFirst');
                  },
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
                RegExp mobile = new RegExp(r"^1\d{10}$");
                RegExp reg = new RegExp(r"^\w{6,}$");
                if (!reg.hasMatch(this.password) || !mobile.hasMatch(this.phoneNum)) {
                  MyToast.show('账号密码不正确');
                  return;
                }
                this._login();
              },
            )
          ],
        ),
      ),
    );
  }
}

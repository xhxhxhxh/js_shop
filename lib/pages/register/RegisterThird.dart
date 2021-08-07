import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/Toast.dart';
import '../../api/dio.dart';
import 'package:provider/provider.dart';
import '../../provider/userInfo.dart';
import '../../api/Storage.dart';
import 'dart:convert';
import '../../pages/Tabs/Tabs.dart';

class RegisterThird extends StatefulWidget {
  final Map arguments;
  RegisterThird({this.arguments});
  @override
  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends State<RegisterThird> {
  String verificationCode;
  String phoneNum;
  String passwords = '';
  String passwords2 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationCode = widget.arguments['code'];
    phoneNum = widget.arguments['phoneNum'];
  }

  _register() async {
    var res = await dio.post('/api/register', data: {
      'tel': this.phoneNum,
      'password': this.passwords,
      'code': this.verificationCode
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
                cb: (value) {
                  this.passwords = value;
                }),
            SizedBox(
              height: 20.w,
            ),
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '请再次输入密码',
                obscureText: true,
                cb: (value) {
                  this.passwords2 = value;
                }),
            SizedBox(
              height: 75.w,
            ),
            MyButton(
              text: '完成注册并登录',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                if (this.passwords2 != this.passwords) {
                  MyToast.show('两次输入的密码不一致');
                  return;
                }
                RegExp reg = new RegExp(r"^\w{6,}$");
                if (!reg.hasMatch(this.passwords)) {
                  MyToast.show('密码不少于6个字符且不能包含特殊字符');
                  return;
                }
                this._register();
//                Navigator.pushNamed(context, '/registerSecond');
              },
            )
          ],
        ),
      ),
    );
  }
}

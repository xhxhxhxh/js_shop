import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/userInfo.dart';
import '../../widgets/MyButton.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    String userName = context.watch<UserInfoProvider>().username;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 220.w,
            padding: EdgeInsets.only(left: 10.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/user_bg.jpg'),
                fit: BoxFit.cover
              )
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset('images/user.png', fit: BoxFit.cover, width: 120.w, height: 120.w,),
                ),
                SizedBox(width: 20.w,),
                InkWell(
                  child: Text(userName == null ? '登录/注册' : userName, style: TextStyle(color: Colors.white, fontSize: 30.sp),),
                  onTap: () {
                    if (userName == null) {
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                )
              ],
            ),
          ),
          ListTile(
            title: Text('全部订单'),
            leading: Icon(Icons.assignment, color: Colors.red),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.green),
            title: Text("待付款"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_car_wash, color: Colors.orange),
            title: Text("待收货"),
          ),
          Container(
              width: double.infinity,
              height: 10,
              color: Color.fromRGBO(242, 242, 242, 0.9)),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.lightGreen),
            title: Text("我的收藏"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text("在线客服"),
          ),
          Divider(),
          userName == null ? Text('') : Container(
            child:  MyButton(
              text: '退出登录',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFffffff),
              textColor: Colors.black87,
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                context.read<UserInfoProvider>().removeInfo();
              },
            ),
          )
        ],
      ),
    );
  }
}

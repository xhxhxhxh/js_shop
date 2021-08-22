import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyButton.dart';

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String checked = '支付宝';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支付'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            InkWell(
              child: Container(
                height: 160.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xFFf7f7f7), width: 2.w))),
                child: Center(
                  child: ListTile(
                      leading: Image.network("https://www.itying.com/themes/itying/images/alipay.png"),
                      title: Text('支付宝'),
                      trailing: this.checked == '支付宝' ? Icon(Icons.check) : Text('')
                  ),
                ),
              ),
              onTap: () {
                this.setState(() {
                  this.checked = '支付宝';
                });
              },
            ),
            InkWell(
              child: Container(
                height: 160.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xFFf7f7f7), width: 2.w))),
                child: Center(
                  child: ListTile(
                      leading: Image.network("https://www.itying.com/themes/itying/images/weixinpay.png"),
                      title: Text('微信'),
                      trailing: this.checked == '微信' ? Icon(Icons.check) : Text('')
                  ),
                ),
              ),
              onTap: () {
                this.setState(() {
                  this.checked = '微信';
                });
              },
            ),
            SizedBox(height: 80.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyButton(
                  text: '支付',
                  width: 700.w,
                  height: 70.w,
                  backgroundColor: Color(0xFFfb191b),
                  borderRadius: BorderRadius.circular(70.w),
                  fontSize: 30.sp,
                  cb: () {

                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

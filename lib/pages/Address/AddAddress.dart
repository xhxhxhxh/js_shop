import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyInput.dart';
import '../../widgets/MyButton.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../api/dio.dart';
import '../../widgets/Toast.dart';
import 'package:provider/provider.dart';
import '../../provider/userInfo.dart';
import '../../api/common.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String area = '省/市/区';
  String userName = '';
  String phoneNum = '';
  String address = '';

  _addAddress() async {
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map params = {
      'uid': userInfo['_id'],
      'name': this.userName,
      'phone': this.phoneNum,
      'address': this.area + ' ' + this.address,
      'salt': userInfo['salt']
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.post('/api/addAddress', data: params);
    Map data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      Navigator.of(context).pop();
    }
    MyToast.show(data['message']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新建收货地址'),
      ),
      body: Container(
        child: ListView(
          children: [
            MyInput(
                height: 90.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '收件人姓名',
                cb: (value){
                  this.userName = value;
                }
            ),
            MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '收件人电话号码',
                keyboardType: TextInputType.number,
                cb: (value){
                  this.phoneNum = value;
                },
            ),
            InkWell(
              child: MyInput(
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                enabled: false,
                text: area,
                cb: (value){
                },
              ),
              onTap: () async {
                Result result = await CityPickers.showCityPicker(
                  context: context,
                    confirmWidget: Text('确定'),
                    cancelWidget: Text('取消')
                );
                print(result);
                if (result != null) {
                  setState(() {
                    this.area = result.provinceName + result.cityName + result.areaName;
                  });
                }
              },
            ),
            MyInput(
                height: 60.w,
                maxLines: 3,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '详细地址',
                cb: (value){
                  this.address = value;
                }
            ),
            SizedBox(height: 75.w,),
            MyButton(
              text: '增加',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                RegExp mobile = new RegExp(r"^1\d{10}$");
                if (!mobile.hasMatch(this.phoneNum)) {
                  MyToast.show('手机号不正确');
                  return;
                }
                if (this.userName == '' || this.area == '省/市/区' || this.address == '') {
                  MyToast.show('请填写姓名和地址信息');
                  return;
                }
                this._addAddress();
              },
            )
          ],
        ),
      ),
    );
  }
}

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

class EditAddressPage extends StatefulWidget {
  final arguments;
  EditAddressPage({this.arguments});
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController area = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNum = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String address = widget.arguments['address'];
    List arr = address.split(' ');
    userName.text = widget.arguments['userName'];
    phoneNum.text = widget.arguments['phoneNum'];
    area.text = arr[0];
    this.address.text = arr[1];
  }

  _editAddress() async {
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map params = {
      'uid': userInfo['_id'],
      'id': widget.arguments['_id'],
      'name': userName.text,
      'phone': phoneNum.text,
      'address': area.text + ' ' + address.text,
      'salt': userInfo['salt']
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.post('/api/editAddress', data: params);
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
        title: Text('编辑收货地址'),
      ),
      body: Container(
        child: ListView(
          children: [
            MyInput(
                controller: userName,
                height: 90.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '收件人姓名',
                cb: (value){
                  userName.text = value;
                }
            ),
            MyInput(
                controller: phoneNum,
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                text: '收件人电话号码',
                keyboardType: TextInputType.number,
                cb: (value){
                  phoneNum .text = value;
                },
            ),
            InkWell(
              child: MyInput(
                controller: area,
                height: 60.w,
                backgroundColor: Colors.white,
                textColor: Color(0xFF737373),
                enabled: false,
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
                    this.area.text = result.provinceName + result.cityName + result.areaName;
                  });
                }
              },
            ),
            MyInput(
                controller: address,
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
              text: '保存',
              width: double.infinity,
              height: 75.w,
              backgroundColor: Color(0xFFfb191b),
              borderRadius: BorderRadius.circular(20.w),
              fontSize: 30.sp,
              cb: () {
                RegExp mobile = new RegExp(r"^1\d{10}$");
                if (!mobile.hasMatch(phoneNum.text)) {
                  MyToast.show('手机号不正确');
                  return;
                }
                if (this.userName.text == '' || this.area.text == '省/市/区' || this.address.text == '') {
                  MyToast.show('请填写姓名和地址信息');
                  return;
                }
                this._editAddress();
              },
            )
          ],
        ),
      ),
    );
  }
}

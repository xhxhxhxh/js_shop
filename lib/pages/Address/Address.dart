import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyButton.dart';
import '../../api/dio.dart';
import '../../widgets/Toast.dart';
import 'package:provider/provider.dart';
import '../../provider/userInfo.dart';
import '../../api/common.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List addressList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getAddress();
  }

  _getAddress() async {
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map<String, dynamic> params = {
      'uid': userInfo['_id'],
      'salt': userInfo['salt']
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.get('/api/addressList', queryParameters: params);
    var data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      setState(() {
        this.addressList = data['result'];
      });
    }
  }

  _setDefaultAddress(id) async{
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map<String, dynamic> params = {
      'uid': userInfo['_id'],
      'salt': userInfo['salt'],
      'id': id
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.post('/api/changeDefaultAddress', data: params);
    var data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  _deleteAddress(id) async{
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map<String, dynamic> params = {
      'uid': userInfo['_id'],
      'salt': userInfo['salt'],
      'id': id
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.post('/api/deleteAddress', data: params);
    var data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      this._getAddress();
    }
    MyToast.show(data['message']);
  }

  _alertDialog(id) async {
    var alertDialogs = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text("确定要删除吗"),
            actions: <Widget>[
              FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.pop(context, "cancel")),
              FlatButton(
                  child: Text("确定"),
                  onPressed: (){
                    this._deleteAddress(id);
                    Navigator.pop(context, "yes");
                  }),
            ],
          );
        });
    return alertDialogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收货地址'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 100.w),
            child: ListView.builder(
                itemCount: this.addressList.length,
                itemBuilder: (context, index) {
                  Map data = this.addressList[index];
                  return InkWell(
                    child: Container(
                      height: 160.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFf7f7f7), width: 2.w))),
                      child: Center(
                        child: ListTile(
                            title: Row(
                              children: [
                                data['default_address'] == 1 ? Container(
                                  height: 36.w,
                                  width: 66.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFfb191b),
                                      borderRadius: BorderRadius.circular(6.w)),
                                  child: Text('默认',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 26.sp)),
                                ): Text(''),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text('${data['name']} ${data['phone']}')
                              ],
                            ),
                            subtitle: Text(data['address']),
                            trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
                              Navigator.pushNamed(context, '/editAddress', arguments: {
                                '_id': data['_id'],
                                'userName': data['name'],
                                'phoneNum': data['phone'],
                                'address': data['address'],
                              })
                                  .then((value) => this._getAddress());
                            },)),
                      ),
                    ),
                    onTap: () {
                      this._setDefaultAddress(data['_id']);
                    },
                    onLongPress: () {
                      this._alertDialog(data['_id']);
                    },
                  );
                }),
          ),
          Positioned(
            bottom: 0,
            width: 750.w,
            child: Container(
              height: 100.w,
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyButton(
                    text: '新建收货地址',
                    width: 700.w,
                    height: 70.w,
                    backgroundColor: Color(0xFFfb191b),
                    borderRadius: BorderRadius.circular(70.w),
                    fontSize: 30.sp,
                    cb: () {
                      Navigator.pushNamed(context, '/addAddress')
                          .then((value) => this._getAddress());
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

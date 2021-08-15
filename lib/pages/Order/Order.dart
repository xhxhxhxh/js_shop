import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provider/cartProvider.dart';
import '../../widgets/MyButton.dart';
import '../../widgets/InputNumber.dart';
import '../../config/config.dart';
import '../../bus/eventBus.dart';
import 'package:provider/provider.dart';
import '../../provider/cartProvider.dart';
import '../../provider/userInfo.dart';
import '../../api/common.dart';
import '../../api/dio.dart';


class OrderPage extends StatefulWidget {
  final Map arguments;
  OrderPage({this.arguments});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List checkedProductList = [];
  Map defaultAddress;
  var bus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkedProductList = widget.arguments['checkedProductList'];
    this._getDefaultAddress();
    this.bus = eventBus.on<ChangeNum>().listen((event) {
      event.data['count'] = event.num;
      context.read<CartProvider>().updateAllPrice();
      context.read<CartProvider>().saveCartData();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.bus.cancel();
  }

  String productAttr(List attr) {
    String text = '';
    attr.forEach((item) {
      String currentText = item['list'][item['selectedIndex']];
      if (text.length > 0) {
        text = text + '/' + currentText;
      } else {
        text += currentText;
      }
    });
    return text;
  }

  _getDefaultAddress() async {
    Map userInfo = context.read<UserInfoProvider>().userInfo[0];
    Map<String, dynamic> params = {
      'uid': userInfo['_id'],
      'salt': userInfo['salt']
    };
    String sign = Api.getSign(params);
    params['sign'] = sign;
    params.remove('salt');
    var res = await dio.get('/api/oneAddressList', queryParameters: params);
    var data = res.data;
    print(data);
    bool success = data['success'];
    if (success) {
      setState(() {
        if (data['result'].length > 0) {
          this.defaultAddress = data['result'][0];
        } else {
          this.defaultAddress = null;
        }
      });
    }
  }

  Widget productItem(data) {
    String url = Config.baseUrl + '/' + data['pic'].replaceAll('\\', '/');
    return Container(
      height: 200.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Color(0xFFf7f7f7), width: 2.w))),
      child: Row(
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            height: 160.w,
            width: 160.w,
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: TextStyle(
                    fontSize: 30.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Container(
                  color: Color(0xFFfafafa),
                  child: Text(
                    productAttr(data['attr']),
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.65)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('￥${data['price']}',
                        style: TextStyle(
                            fontSize: 30.sp, color: Color(0xFFf4483b))),
                    InputNumber(defaultNumber: data['count'], data: data)
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('结算'),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.w, bottom: 100.w),
              child: ListView(
                children: [
                  InkWell(
                    child: Container(
                      height: 120.w,
                      color: Colors.white,
                      child: Center(
                        child:  ListTile(
                            leading: Icon(Icons.location_on),
                            title: defaultAddress != null ? Text('${defaultAddress['name']} ${defaultAddress['phone']}') : Text('请添加收货地址'),
                            subtitle: defaultAddress != null ? Text('${defaultAddress['address']}') : null,
                            trailing: Icon(Icons.arrow_forward_ios)),
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/address').then((value) => this._getDefaultAddress());
                    },
                  ),
                  SizedBox(
                    height: 40.w,
                  ),
                  ...checkedProductList.map((item) {
                    return productItem(item);
                  }).toList(),
                  SizedBox(
                    height: 40.w,
                  ),
                  Container(
                    height: 70.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFf7f7f7), width: 2.w))),
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      children: [
                        Text('商品总金额:￥${context.watch<CartProvider>().allPrice}',
                            style: TextStyle(fontSize: 30.sp))
                      ],
                    ),
                  ),
                  Container(
                    height: 70.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFf7f7f7), width: 2.w))),
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      children: [
                        Text('立减:￥120', style: TextStyle(fontSize: 30.sp))
                      ],
                    ),
                  ),
                  Container(
                    height: 70.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFf7f7f7), width: 2.w))),
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      children: [
                        Text('运费:￥120', style: TextStyle(fontSize: 30.sp))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              width: 750.w,
              child: Container(
                height: 100.w,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xFFdedede), width: 2.w))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '总价:￥${context.watch<CartProvider>().allPrice}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 29.sp,
                          color: Color(0xFFf4483b)),
                    ),
                    MyButton(
                      text: '立即下单',
                      width: 180.w,
                      height: 70.w,
                      backgroundColor: Color(0xFFfb191b),
                      borderRadius: BorderRadius.circular(5.w),
                      fontSize: 30.sp,
                      cb: () {},
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

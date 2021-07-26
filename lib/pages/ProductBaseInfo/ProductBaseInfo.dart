import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../../widgets/MyButton.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../widgets/LoadingWidget.dart';
import '../../bus/eventBus.dart';
import '../../widgets/InputNumber.dart';
import 'package:provider/provider.dart';
import '../../provider/cartProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductBaseInfo extends StatefulWidget {
  final String id;
  ProductBaseInfo({this.id});
  @override
  _ProductBaseInfoState createState() => _ProductBaseInfoState();
}

class _ProductBaseInfoState extends State<ProductBaseInfo>
    with AutomaticKeepAliveClientMixin {
  Map content;
  List attr;
  int num = 1;
  var bus;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getProductInfo();
    this.bus = eventBus.on<HandleBus>().listen((event) {
      this.showBottomModal();
    });
    eventBus.on<ChangeNum>().listen((event) {
      this.num = event.num;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.bus.cancel();
  }

  void _getProductInfo() async {
    String url = '/api/pcontent?id=${widget.id}';
    print(url);
    var res = await dio.get(url);
    Map result = res.data['result'];
    print(result);
    this.setState(() {
      this.content = result;
      this.attr = result['attr'];
      this.attr.forEach((item) {
        item['selectedIndex'] = 0;
      });
    });
  }

  List<Widget> selectItem(setBottomState) {
    print(this.attr);
    return this.attr.map<Widget>((item) {
      return Container(
        margin: EdgeInsets.only(bottom: 50.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: 125.w,
              height: 70.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['cate'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                  )
                ],
              ),
            ),
            Expanded(
                child: Wrap(
                    spacing: 45.w,
                    runSpacing: 10.w,
                    children: item['list'].asMap().keys.map<Widget>((index) {
                      String text = item['list'][index];
                      return InkWell(
                        onTap: () {
                          setBottomState(() {
                            item['selectedIndex'] = index;
                          });
                        },
                        child: Chip(
                            backgroundColor: item['selectedIndex'] == index
                                ? Color(0xFFfb191b)
                                : Color(0xFFededed),
                            padding: EdgeInsets.all(0),
                            label: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(text,
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: item['selectedIndex'] == index
                                              ? Colors.white
                                              : Colors.black))
                                ],
                              ),
                              width: 130.w,
                              height: 75.w,
                            )),
                      );
                    }).toList()))
          ],
        ),
      );
    }).toList();
  }

  Widget ProductNum() {
    return Container(
      margin: EdgeInsets.only(bottom: 50.w),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 125.w,
            height: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '数量',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                )
              ],
            ),
          ),
          InputNumber(defaultNumber: num)
        ],
      ),
    );
  }

  // 弹出底部modal
  showBottomModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, setBottomState) {
            return GestureDetector(
              onTap: () {
                return false;
              },
              child: Stack(
                children: [
                  Container(
                    height: 520.w,
                    padding: EdgeInsets.only(top: 35.w, bottom: 100.w),
                    child: ListView(
                      children: [
                        ...this.selectItem(setBottomState),
                        ProductNum()
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      width: 750.w,
                      child: Container(
                        height: 100.w,
                        padding: EdgeInsets.only(top: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyButton(
                              text: '加入购物车',
                              width: 335.w,
                              height: 70.w,
                              backgroundColor: Color(0xFFfb191b),
                              borderRadius: BorderRadius.circular(20.w),
                              fontSize: 30.sp,
                              cb: () {
                                context.read<CartProvider>().addProduct({
                                  ...this.content,
                                  'count': this.num,
                                  'attrStr': json.encode(this.attr),
                                  'checked': true
                                });
                                Fluttertoast.showToast(
                                  msg: "加入购物车成功",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.black,
                                );
                                Navigator.pop(context);
                              },
                            ),
                            MyButton(
                              text: '立即购买',
                              width: 335.w,
                              height: 70.w,
                              backgroundColor: Color(0xFFfcac17),
                              borderRadius: BorderRadius.circular(20.w),
                              fontSize: 30.sp,
                              cb: () {},
                            )
                          ],
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (content == null) {
      return LoadingWidget();
    }
    String url = Config.baseUrl + '/' + content['pic'].replaceAll('\\', '/');
    return Container(
      padding: EdgeInsets.all(20.w),
      child: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(url, fit: BoxFit.contain),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.w),
            alignment: Alignment.center,
            child: Text(content['title'],
                style: TextStyle(color: Colors.black87, fontSize: 36.w)),
          ),
          Container(
              margin: EdgeInsets.only(top: 20.w),
              alignment: Alignment.center,
              child: Text(
                  content['sub_title'] == null ? '' : content['sub_title'],
                  style: TextStyle(color: Colors.black54, fontSize: 28.w))),
          //价格
          Container(
            margin: EdgeInsets.only(top: 20.w),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text("特价: "),
                      Text("¥${content['price']}",
                          style: TextStyle(color: Colors.red, fontSize: 46.sp)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("原价: "),
                      Text("¥${content['old_price']}",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 30.sp,
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                )
              ],
            ),
          ),
          //筛选
          InkWell(
            onTap: showBottomModal,
            child: Container(
              margin: EdgeInsets.only(top: 40.w),
              height: 80.w,
              child: Row(
                children: <Widget>[
                  Text("已选: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("115，黑色，XL，1件")
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            height: 80.w,
            child: Row(
              children: <Widget>[
                Text("运费: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费")
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

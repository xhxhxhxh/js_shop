import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/InputNumber.dart';
import '../../config/config.dart';
import '../../bus/eventBus.dart';
import 'package:provider/provider.dart';
import '../../provider/cartProvider.dart';

class CartItem extends StatefulWidget {
  final Map data;
  CartItem(Key key,this.data):super(key: key);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Map data;
  bool checked;
  var bus;
  var checkedBus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.data = widget.data;
    this.checked = this.data['checked'] == null ? true : this.data['checked'];
    this.bus = eventBus.on<ChangeNum>().listen((event) {
      if (event.data == this.data) {
        print('111');

        event.data['count'] = event.num;
        context.read<CartProvider>().updateAllPrice();
        context.read<CartProvider>().saveCartData();
      }
    });
//    this.checkedBus = eventBus.on<ChangeCheckedStatus>().listen((event) {
//      this.setState(() {
//        this.checked = event.status;
//      });
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.bus.cancel();
//    this.checkedBus.cancel();
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

  @override
  Widget build(BuildContext context) {
    String url = Config.baseUrl + '/' + data['pic'].replaceAll('\\', '/');
    this.checked = this.data['checked'];
    return Container(
      height: 150.w,
      margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -18, offset: Offset(0, 2))]
      ),
      child: Row(
        children: [
          Checkbox(value: this.checked,
            onChanged: (val){
            print(val);
              setState(() {
                this.checked = val;
                this.data['checked'] = val;
                context.read<CartProvider>().updateCheckedAll();
              });
            },
            activeColor: Color(0xFFf54438),),
          Image.network(
            url,
            fit: BoxFit.cover,
            height: 100.w,
            width: 100.w,
          ),
          SizedBox(width: 20.w,),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'], style: TextStyle(fontSize: 30.sp,), overflow: TextOverflow.ellipsis, maxLines: 1,),
                  Container(
                    color: Color(0xFFfafafa),
                    child: Text(productAttr(data['attr']), style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.65)
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('￥${data['price']}', style: TextStyle(fontSize: 30.sp)),
                      InputNumber(defaultNumber: data['count'], data: data)
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}

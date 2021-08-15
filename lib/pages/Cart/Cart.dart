import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/cartProvider.dart';
import '../../widgets/MyButton.dart';
import './CartItem.dart';
import '../../provider/userInfo.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    bool checkedAll = context.watch<CartProvider>().checkedAll;
    List productList = context.watch<CartProvider>().productList;
    if (productList == null) {
      productList = [];
    }
    List checkedProductList = productList.where((element) => element['checked']).toList();
    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.plus_one),
//        onPressed: () => context.read<CartProvider>().increment(),
//      ),
      appBar: AppBar(
        title: Text('购物车'),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.only(right: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(isEdit ? '完成' : '编辑')],
              ),
            ),
            onTap: () {
              setState(() {
                this.isEdit = !this.isEdit;
              });
            },
          )
        ],
      ),
//      body: Center(
//        child: Text(context.watch<CartProvider>().count.toString()),
//      )
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.w, bottom: 75.w),
            child: productList.length > 0 ? ListView(
              children: productList.map((item){
                return CartItem(ValueKey(item['_id']), item);
              }).toList(),
            ) : Center(
              child: Text('购物车是空的'),
            ),
          ),
          Positioned(
            bottom: 0,
            width: 750.w,
            child: Container(
              height: 75.w,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFdedede), width: 2.w))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: checkedAll,
                        onChanged: (val){
                          context.read<CartProvider>().setCheckedAll(val);
                        },
                        activeColor: Color(0xFFf54438),),
                      Text('全选'),
                      SizedBox(width: 15.w,),
                      Text(isEdit ? '': '合计:￥${context.read<CartProvider>().allPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29.sp),)
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.w),
                    child: MyButton(
                      text: isEdit ? '删除': '结算(${checkedProductList.length})',
                      width: 180.w,
                      height: 70.w,
                      backgroundColor: Color(0xFFfb191b),
                      borderRadius: BorderRadius.circular(5.w),
                      fontSize: 30.sp,
                      cb: (){
                        if (isEdit) {
                          context.read<CartProvider>().removeProduct();
                        } else {
                          String username = context.read<UserInfoProvider>().username;
                          if (username != null) {
                            if (checkedProductList.length > 0) {
                              Navigator.pushNamed(context, '/order', arguments: {'checkedProductList': checkedProductList});
                            }
                          } else {
                            Navigator.pushNamed(context, '/login');
                          }
                        }
                      },
                    ),
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

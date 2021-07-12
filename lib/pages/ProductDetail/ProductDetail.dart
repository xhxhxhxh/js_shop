import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/MyButton.dart';
import '../ProductBaseInfo/ProductBaseInfo.dart';
import '../ProductInformation/ProductInformation.dart';

class ProductDetailPage extends StatefulWidget {
  final Map arguments;
  ProductDetailPage({this.arguments});
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget tabBar() {
    return  AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400.w,
            child: TabBar(
              indicatorColor: Color(0xFFe43733),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(
                  child: Text('商品'),
                ),
                Tab(
                  child: Text('详情'),
                ),
                Tab(
                  child: Text('评价'),
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        IconButton(icon: Icon(Icons.more_horiz), onPressed: this._showMenu)
      ],
    );
  }

  Widget body() {
    return Stack(
      children: [
        TabBarView(
          children: <Widget>[
            ProductBaseInfo(id: widget.arguments['id']),
            ProductInformation(id: widget.arguments['id']),
            Text('333'),
          ],
        ),
        Positioned(
          bottom: 0,
          width: 750.w,
          child: Container(
            height: 90.w,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 2.w,
                  color: Color(0xFFe8e8e8)
                )
              ),
              color: Color(0xFFFFFFFF)
            ),
            child: Row(
              children: [
                Container(
                  width: 210.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart),
                      Text('购物车')
                    ],
                  ),
                ),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                      text: '加入购物车',
                      width: 230.w,
                      height: 70.w,
                      backgroundColor: Color(0xFFfb191b),
                      borderRadius: BorderRadius.circular(20.w),
                      fontSize: 30.sp,
                      cb: (){

                      },
                    ),
                    MyButton(
                      text: '立即购买',
                      width: 230.w,
                      height: 70.w,
                      backgroundColor: Color(0xFFfcac17),
                      borderRadius: BorderRadius.circular(20.w),
                      fontSize: 30.sp,
                      cb: (){

                      },
                    )
                  ],
                ))
              ],
            ),
          )
        )
      ],
    );
  }

  _showMenu(){
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(600.w, 130.w, 10.w, 0),
      items: [
        PopupMenuItem(child: Row(
          children: [
            Icon(Icons.home),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              child: Text('首页'),
            )
          ],
        )),
        PopupMenuItem(child: Row(
          children: [
            Icon(Icons.search),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              child: Text('搜索'),
            )
          ],
        ))
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: tabBar(),
        body: body(),
      ),
    );
  }
}

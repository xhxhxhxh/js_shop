import 'package:flutter/material.dart';
import 'package:jd_shop/pages/Home/Home.dart';
import 'package:jd_shop/pages/Category/Category.dart';
import 'package:jd_shop/pages/Cart/Cart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  PageController _pageController;
  List<Widget> _pageList = [
    HomePage(),
    CategoryPage(),
    CartPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    this._pageController = new PageController(initialPage:_currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Icon(Icons.center_focus_weak, size: 44.sp, color: Colors.black87),
                onTap: (){},
              ),
              SizedBox(width: 20.w,),
              Expanded(
                  child: InkWell(
                    child: Container(
                      height: 60.w,
                      padding: EdgeInsets.only(left: 20.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFd8d8d8),
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 40.sp, color: Colors.white),
                          SizedBox(width: 18.w,),
                          Text('笔记本', style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp
                          ))
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/search');
                    },
                  )
              ),
              SizedBox(width: 20.w,),
              InkWell(
                child: Icon(Icons.message, size: 44.sp, color: Colors.black87),
                onTap: (){},
              ),
            ],
          ),
        ),
//        body: this._pageList[this._currentIndex],
//        body: IndexedStack(
//          index: this._currentIndex,
//          children: this._pageList,
//        ),

        body: PageView(
          children: this._pageList,
          controller: this._pageController,
          onPageChanged: (index) {
            setState(() { // 滑动切换时
              this._currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0xFFe1251b),
          selectedFontSize: 12.0,
          currentIndex: this._currentIndex,
          onTap: (int index){
            setState(() {
              this._currentIndex = index;
              _pageController.jumpToPage(this._currentIndex);
            });
          },
          type: BottomNavigationBarType.fixed, // 当图标过多时不会挤下去
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '首页'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: '分类'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: '购物车'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '我的'
            )
          ],
        )
    );
  }
}

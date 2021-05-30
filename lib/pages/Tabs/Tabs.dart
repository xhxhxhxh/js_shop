import 'package:flutter/material.dart';
import 'package:jd_shop/pages/Home/Home.dart';
import 'package:jd_shop/pages/Category/Category.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  PageController _pageController;
  List<Widget> _pageList = [
    HomePage(),
    CategoryPage()
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
          title: Text('京东'),
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
//            this._currentIndex = index;
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

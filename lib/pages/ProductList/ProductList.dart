import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../widgets/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  final Map arguments;
  ProductListPage({this.arguments});
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int selectedTab = 1;
  int page = 1;
  int pageSize = 8;
  bool flag = false;
  String sortType;
  int sort = 1;
  List productList = [];
  List tabItems = [
    {'id': 1, 'label': '综合'},
    {'id': 2, 'label': '销量', 'sort': 1, 'sortType': 'salecount'},
    {'id': 3, 'label': '价格', 'sort': 1, 'sortType': 'price'},
    {'id': 4, 'label': '筛选'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double currentHeight = _scrollController.position.pixels;
      double totalHeight = _scrollController.position.maxScrollExtent;

      if (currentHeight > totalHeight - 40) {
        this._getProductList();
      }
    });
    this._getProductList();
  }

  // 重置tabItems的sort
  void initSort(){
    tabItems.forEach((element) {
      if (element['sort'] != null) {
        element['sort'] = 1;
      }
    });
  }

  void _getProductList() async {
    if (this.flag) return;

    this.setState(() {
      this.flag = true;
    });

    var res = await dio.get(
        '/api/plist?page=${this.page}&pageSize=${this.pageSize}&cid=${widget.arguments['_id']}&sort=${sortType != null ? sortType + '_' + sort.toString() : ''}');
    List result = res.data['result'];
    print(result);
    this.setState(() {
      this.flag = false;
      if (result.length > 0) {
        this.page++;
      }
      this.productList.addAll(result);
    });
  }

  Widget ShowMore(index){
    if (index == this.productList.length - 1 && this.flag) {
      return LoadingWidget();
    }
    return Text('', style: TextStyle(fontSize: 0),);
  }
  Widget _showIcon(id){
    if (id != this.selectedTab) {
      return Text('');
    }
    if(this.sortType != null ){
      if(this.sort == 1){
        return Icon(Icons.arrow_drop_down);
      }
      return Icon(Icons.arrow_drop_up);
    }
    return Text('');
  }
  Widget TopBar() {
    return Positioned(
        top: 0,
        child: Container(
          height: 80.w,
          width: 750.w,
          color: Colors.white,
          child: Row(
            children: tabItems.map((item) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    this.setState(() {
                      if (item['id'] != 4) {
                        if (this.selectedTab != item['id']) {
                          initSort();
                          this.sortType = item['sortType'];
                        }
                        this.selectedTab = item['id'];
                        this.productList = [];
                        this.page = 1;
                        _scrollController.jumpTo(0);
                        int sort = item['sort'];

                        if (sort != null) {
                          this.sort = sort;
                          item['sort'] = -sort;
                        }
                        this._getProductList();
                      } else {
                        _scaffoldKey.currentState.openEndDrawer();
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.w,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: selectedTab == item['id']
                                  ? Color(0xFFf54f42)
                                  : Color(0xFFe6e6e6),
                              width: 2.w)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['label'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: selectedTab == item['id']
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                            _showIcon(item['id'])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget ProductList() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      margin: EdgeInsets.only(top: 80.w),
      color: Color(0xFFf7f7f7),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: this.productList.length,
        itemBuilder: (context, index) {
          Map currentData = this.productList[index];
          String url =
              Config.baseUrl + '/' + currentData['pic'].replaceAll('\\', '/');
          return Column(
            children: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 30.w, bottom: 15.w),
                  height: 245.w,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xFFe6e6e6), width: 2.w))),
                  child: Row(
                    children: [
                      Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: 180.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentData['title'],
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          Row(
                            children: [
                              Container(
                                height: 36.w,
                                width: 72.w,
                                child: Text('4g', textAlign: TextAlign.center),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.w),
                                    color: Color(0xFFe6e6e6)),
                              )
                            ],
                          ),
                          Text(
                            '¥' + currentData['price'].toString(),
                            style: TextStyle(
                                color: Color(0xFFf42819), fontSize: 27.sp),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              ShowMore(index)
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('商品列表'),
        actions: [Text('')],
      ),
      body: Stack(
        children: [ProductList(), TopBar()],
      ),
      endDrawer: Drawer(
        child: Text('筛选'),
      ),
    );
  }
}

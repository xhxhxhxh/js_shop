import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../widgets/LoadingWidget.dart';
import '../../api/Storage.dart';

var storage = Storage();

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
  bool noData = false;
  String sortType;
  int sort = 1;
  String _keyword = '';
  List productList = [];
  var _initKeywordsController = new TextEditingController();
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
    this._keyword = this._initKeywordsController.text = widget.arguments['keyword'];
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

  // 重置page等参数
  void initParams(){
    this.productList = [];
    this.page = 1;
    _scrollController.jumpTo(0);
  }

  void _getProductList() async {
    if (this.flag) return;

    this.setState(() {
      this.flag = true;
    });

    String url = '';
    if (this._keyword != null) {
      url = '/api/plist?page=${this.page}&pageSize=${this.pageSize}&search=${this._keyword}&sort=${sortType != null ? sortType + '_' + sort.toString() : ''}';
    } else {
      url = '/api/plist?page=${this.page}&pageSize=${this.pageSize}&cid=${widget.arguments['_id']}&sort=${sortType != null ? sortType + '_' + sort.toString() : ''}';
    }
    print(url);
    var res = await dio.get(url);
    List result = res.data['result'];
    print(result);
    this.setState(() {
      this.flag = false;
      if (result.length > 0) {
        this.page++;
        this.noData = false;
      } else {
        if (this.page == 1) {
          this.noData = true;
        }
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

  Widget NoData() {
    return this.noData ? Center(
      child: Text('没有找到这个商品'),
    ) : Text('');
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
                        this.initParams();
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
                onTap: (){
                  Navigator.pushNamed(context, '/productDetail', arguments: { 'id':  currentData['_id']});
                },
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
//        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:Container(
                height: 60.w,
                child: TextField(
                  autofocus: false,
                  controller: _initKeywordsController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.w),
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.w),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Color(0xFFd8d8d8),
                  ),
                  onChanged: (value){
                    this._keyword = value;
                  },
                ),
              ),
            ),
            SizedBox(width: 20.w,),
            InkWell(
              child: Text('搜索', style: TextStyle(
                  fontSize: 32.sp
              )),
              onTap: (){
                this.initParams();
                this._getProductList();
                storage.setSearchHistory(this._keyword);
              },
            ),
          ],
        ),
        actions: [
          Text('')
        ],
      ),
      body: Stack(
        children: [ProductList(), TopBar(), NoData()],
      ),
      endDrawer: Drawer(
        child: Text('筛选'),
      ),
    );
  }
}

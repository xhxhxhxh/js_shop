import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../widgets/TopAppBar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List bannerList = [];
  List hotProductsList = [];
  List popularRecommendationList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    this._getBannerData();
    this._getHotProductsData();
    this._getPopularRecommendationData();
    print('home');
  }

  _getBannerData() async{
    var res = await dio.get('/api/focus');
    List result = res.data['result'];
    this.setState(() {
      this.bannerList = result;
    });
//    print(result);
  }

  _getHotProductsData() async{
    var res = await dio.get('/api/plist?is_best=1');
    List result = res.data['result'];
    this.setState(() {
      this.hotProductsList = result;
    });
//    print(result);
  }

  _getPopularRecommendationData() async{
    var res = await dio.get('/api/plist?is_hot=1');
    List result = res.data['result'];
    this.setState(() {
      this.popularRecommendationList = result;
    });
    print(result);
  }

  // 轮播图
  Widget swiperContainer(){
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          String url = Config.baseUrl + '/' + bannerList[index]['pic'].replaceAll('\\', '/');
          return new Image.network(url,fit: BoxFit.fill,);
        },
        autoplay: true,
        itemCount: bannerList.length,
        pagination: new SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Color(0xFFe1251b)
          )
        ),
        control: new SwiperControl(
          color: Color(0xFFe1251b)
        ),
      )
    );
  }

  // 标题
  Widget titleContainer(text) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(10),
            height: ScreenUtil().setWidth(32),
            decoration: new BoxDecoration(color: Color(0xFFf44336)),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Text(text, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  // 横向滚动列表
  Widget hotProducts() {
    return Container(
      height: 150.w,
      margin: EdgeInsets.only(top: 20.w),
      padding: EdgeInsets.only(left: 20.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          String url = Config.baseUrl + '/' + hotProductsList[index]['pic'].replaceAll('\\', '/');
          return Container(
            padding: EdgeInsets.only(right: 20.w),
            height: double.infinity,
            width: 120.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(url,
                  fit: BoxFit.cover,
                  height: 100.w,
                  width: 100.w,
                ),
                Text(hotProductsList[index]['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,)
              ],
            ),
          );
      },
      itemCount: hotProductsList.length),
    );
  }

  // 热门推荐
  Widget popularRecommendation() {
    return Container(
      margin: EdgeInsets.only(top: 20.w),
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Wrap(
        runSpacing: 20.w,
        alignment: WrapAlignment.spaceBetween,
        children: popularRecommendationList.map((e) => product(e)).toList(),
      ),
    );
  }

  Widget product(value) {
    String url = Config.baseUrl + '/' + value['pic'].replaceAll('\\', '/');
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/productDetail', arguments: { 'id':  value['_id']});
      },
      child: Container(
        width: 342.w,
        height: 480.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(url, fit: BoxFit.cover, height: 300.w),
            Text(
              value['title'],
              maxLines: 2,
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xFF646464), fontSize: 27.sp),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('¥' + value['price'].toString(),textScaleFactor: 1.0,style: TextStyle(color: Color(0xFFf32b1d), fontSize: 29.sp)),
                Text(
                    '¥' + value['old_price'].toString(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF282828),
                        fontSize: 24.sp,
                        decoration: TextDecoration.lineThrough))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: TopAppBar.bar(context),
      body: ListView(
        children: [
          swiperContainer(),
          titleContainer('猜你喜欢'),
          hotProducts(),
          titleContainer('热门推荐'),
          popularRecommendation()
        ],
      ),
    );
  }
}

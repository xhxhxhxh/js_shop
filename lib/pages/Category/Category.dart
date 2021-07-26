import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../widgets/TopAppBar.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin{
  int selectedIndex = 0;
  List leftListData = [];
  List rightListData = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._getLeftList();
    print('cate');
  }

  void _getLeftList() async {
    var res = await dio.get('/api/pcate');
    List result = res.data['result'];
//    print(result);
    this._getRightList(result[0]['_id']);
    this.setState(() {
      this.leftListData = result;
    });
  }

  void _getRightList(id) async {
    var res = await dio.get('/api/pcate?pid=' + id);
    List result = res.data['result'];
//    print(result);
    this.setState(() {
      this.rightListData = result;
    });
  }

  Widget LeftList() {
    return Container(
      width: 175.w,
      child: ListView.builder(
        itemCount: this.leftListData.length,
        itemBuilder: (context, index) {
          Map currentData = this.leftListData[index];
          return InkWell(
            onTap: () {
              this.setState(() {
                this.selectedIndex = index;
                this._getRightList(currentData['_id']);
              });
            },
            child: Container(
              height: 85.w,
              decoration: BoxDecoration(
                  color: this.selectedIndex == index ? Color(0xFFf1f5f6) : Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFf1f5f6), width: 2.w))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      currentData['title'],
                      style: TextStyle(color: this.selectedIndex == index ? Color(0xFFff4a68) : Colors.black)
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget RightList() {
    return Expanded(
      child: Container(
      color: Color(0xFFf1f5f6),
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.w),
        child: GridView.builder(
            itemCount:this.rightListData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5 / 2,
                mainAxisSpacing: 20.w,
                crossAxisSpacing: 20.w
            ),
            itemBuilder: (context, index){
              Map currentData = this.rightListData[index];
              String url = Config.baseUrl + '/' + currentData['pic'].replaceAll('\\', '/');
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/productList', arguments: {
                    '_id': currentData['_id']
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      url,
                      fit: BoxFit.cover,
//                        width: 120.w,
//                        height: 120.w,
                    ),
                    Text(currentData['title'], style: TextStyle(color: Color(0xFF626262)),)
                  ],
                ),
              );
            }
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: TopAppBar.bar(context),
      body: Row(
        children: [
          LeftList(),
          RightList()
        ],
      ),
    );
  }
}

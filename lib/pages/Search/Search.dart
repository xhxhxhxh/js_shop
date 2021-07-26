import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api/dio.dart';
import '../../config/config.dart';
import '../../api/Storage.dart';

var storage = Storage();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _keyword = '';
  List _searchList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getSearchList();
  }

  getSearchList() async {
    List searchList = await storage.getStorage('searchList');
    this.setState(() {
      if (searchList != null) {
        _searchList = searchList;
      } else {
        _searchList = [];
      }
    });
  }

  _alertDialog(text) async {
    var alertDialogs = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text("确定要删除吗"),
            actions: <Widget>[
              FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.pop(context, "cancel")),
              FlatButton(
                  child: Text("确定"),
                  onPressed: (){
                    Navigator.pop(context, "yes");
                    this.setState(() {
                      this._searchList.remove(text);
                      storage.setStorage('searchList', this._searchList, type: 'list');
                    });

                  }),
            ],
          );
        });
    return alertDialogs;
  }

  @override
  Widget Title(name) {
    return Container(
      height: 80.w,
      margin: EdgeInsets.only(bottom: 36.w),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFf2f2f2)))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(
              fontSize: 36.sp
          ),)
        ],
      ),
    );
  }

  Widget ListTitle(name) {
    return Container(
      height: 150.w,
      padding: EdgeInsets.only(left: 20.w),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFf2f2f2), width: 2.w))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(
              fontSize: 32.sp
          ),)
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:Container(
                  height: 60.w,
                  child: TextField(
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '笔记本',
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
              onTap: () async{
                Navigator.pushReplacementNamed(context, '/productList', arguments: { 'keyword':  this._keyword});
                await storage.setSearchHistory(this._keyword);
                this.getSearchList();
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        children: [
          Title('热搜'),
          Wrap(
            spacing: 40.w,
            runSpacing: 40.w,
            children: [
              Container(
                width: 100.w,
                height: 70.w,
                decoration: BoxDecoration(
                    color: Color(0xFFeaeaea),
                    borderRadius: BorderRadius.circular(16.w)
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('女装', style: TextStyle(
                        fontSize: 26.sp
                    ),)
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.w,),
          Title('历史纪录'),
          Column(
            children:  _searchList.map((text){
              return ListTile(
                title: Container(
                  child: ListTitle(text),
                ),
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/productList', arguments: { 'keyword': text});
                  storage.setSearchHistory(text);
                },
                onLongPress: () {
                  this._alertDialog(text);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 200.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400.w,
                height: 65.w,
                child: OutlinedButton(
                  onPressed: () async {
                    await storage.removeStorage('searchList');
                    this.getSearchList();
                  },
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete,),
                    Text('清除历史记录')
                  ],
                )),
              )
            ],
          )
        ],
      )
    );
  }
}

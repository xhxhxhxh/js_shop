import 'package:flutter/material.dart';
import 'dart:convert';
import '../api/Storage.dart';

var storage = Storage();

class UserInfoProvider with ChangeNotifier {
  List userInfo;
  String username;

  UserInfoProvider() {
    this.init();
  }

  // 读取缓存数据
  init() async {
    String data = await storage.getStorage('userInfo');
    if (data == null) {
      this.userInfo = [];
      this.username = null;
    } else {
      this.userInfo = json.decode(data);
      print(this.userInfo);
      this.username = this.userInfo[0]['username'];
    }
    notifyListeners();
  }

  removeInfo() async {
    await storage.removeStorage('userInfo');
    this.userInfo = [];
    this.username = null;
    notifyListeners();
  }
}
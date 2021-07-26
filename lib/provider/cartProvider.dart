import 'package:flutter/material.dart';
import 'dart:convert';
import '../api/Storage.dart';
import '../bus/eventBus.dart';

var storage = Storage();

class CartProvider with ChangeNotifier {
  List _productList;
  bool checkedAll = false;
  double allPrice;

  CartProvider() {
    this.init();
  }

  List get productList => _productList;

  // 读取缓存数据
  init() async {
    String data = await storage.getStorage('productList');
    if (data == null) {
      this._productList = [];
    } else {
      this._productList = json.decode(data);
    }
    this.updateCheckedAll();
  }

  void addProduct(data) {
//    print('data');
//    print(data);
    print(this._productList);
    Map currentItem = this._productList.firstWhere((item) {
      return item['_id'] == data['_id'] && item['attrStr'] == data['attrStr'];
    },orElse: () => null);
    print(currentItem);
    if (currentItem == null) {
      this._productList.insert(0, data);
    } else {
      currentItem['count'] += data['count'];
    }
    this.updateAllPrice();
    this.saveCartData();
    notifyListeners();
  }

  updateCheckedAll() {
    bool checkedAll = true;
    this._productList.forEach((item) {
      if (item['checked'] == null) {
        item['checked'] = true;
      }
      if (!item['checked']) {
        checkedAll = false;
      }
    });
    this.checkedAll = checkedAll;
    this.updateAllPrice();
    this.saveCartData();
    notifyListeners();
  }

  setCheckedAll(bool state) {
    this._productList.forEach((item) {
      item['checked'] = state;
    });
    this.checkedAll = state;
    this.updateAllPrice();
    this.saveCartData();
//    eventBus.fire(ChangeCheckedStatus(state));
    notifyListeners();
  }

  updateAllPrice() {
    double allPrice = 0;
    this._productList.forEach((item) {
      bool checked = item['checked'];
      item['price'] = item['price'].toString();
      item['price'] = double.parse(item['price']);
      double price = item['price'];
      if (checked) {
        allPrice += price * item['count'];
      }
    });
    this.allPrice = allPrice;
    notifyListeners();
  }

  removeProduct() {
    for (int i = 0; i < this._productList.length; i++) {
      Map currentProduct = this._productList[i];
      if (currentProduct['checked']) {
        this._productList.remove(currentProduct);
        i--;
      }
    }
    this.updateAllPrice();
    notifyListeners();
  }

  saveCartData() {
    storage.setStorage('productList', json.encode(this._productList));
  }
}
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Api {
  static getSign(Map data) {
    List keys = data.keys.toList();
    keys.sort();
    String str = '';
    keys.forEach((key) {
      str += (key + data[key]);
    });
    return md5.convert(utf8.encode(str)).toString();
  }
}
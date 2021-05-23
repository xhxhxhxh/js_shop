import 'package:dio/dio.dart';
import '../config/config.dart';

var options = BaseOptions(
  baseUrl: Config.baseUrl,
);
Dio dio = Dio(options);




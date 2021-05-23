import 'package:flutter/material.dart';
import 'router/Router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: () => MaterialApp(
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute
      ),
    );
  }
}


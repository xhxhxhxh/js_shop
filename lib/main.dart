import 'package:flutter/material.dart';
import 'router/Router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import './provider/cartProvider.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider(), lazy: false,),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: () => MaterialApp(
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
        theme: ThemeData(
            primaryColor: Colors.white
        ),
      ),
    );
  }
}


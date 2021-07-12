import 'package:flutter/material.dart';
import '../pages/Tabs/Tabs.dart';
import '../pages/ProductList/ProductList.dart';
import '../pages/Search/Search.dart';
import '../pages/ProductDetail/ProductDetail.dart';


final routes = {
  '/': (context, {arguments}) => Tabs(),
  '/productList': (context, {arguments}) => ProductListPage(arguments: arguments),
  '/search': (context, {arguments}) => SearchPage(),
  '/productDetail': (context, {arguments}) => ProductDetailPage(arguments: arguments),
};

Route onGenerateRoute (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (settings.arguments != null) {
    final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context,
            arguments: settings.arguments));
    return route;
  } else {
    final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context));
    return route;
  }
}
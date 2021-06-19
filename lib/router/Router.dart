import 'package:flutter/material.dart';
import '../pages/Tabs/Tabs.dart';
import '../pages/ProductList/ProductList.dart';


final routes = {
  '/': (context, {arguments}) => Tabs(),
  '/productList': (context, {arguments}) => ProductListPage(arguments: arguments),
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
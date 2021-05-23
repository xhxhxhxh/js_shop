import 'package:flutter/material.dart';
import '../pages/Tabs/Tabs.dart';


final routes = {
  '/': (context, {arguments}) => Tabs(),
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
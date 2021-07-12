import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../config/config.dart';

class ProductInformation extends StatefulWidget{
  final String id;
  ProductInformation({this.id});
  @override
  _ProductInformationState createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child:  InAppWebView(
          initialUrl: Config.baseUrl + '/pcontent?id=${widget.id}'
      ),
    );
  }
}

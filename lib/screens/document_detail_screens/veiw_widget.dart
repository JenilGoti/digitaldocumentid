import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewWidget extends StatelessWidget {
  const ViewWidget({Key? key, required this.details, required this.detailKey}) : super(key: key);
  final Map<String, dynamic> details;
  final String detailKey;


  @override
  Widget build(BuildContext context) {
      return Text(details[detailKey],textScaleFactor: 1.3,);
  }
}

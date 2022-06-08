
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';

class DocumentScan extends StatelessWidget {
  DocumentScan({Key? key, required this.PickDocument, required this.imageKey}) : super(key: key);

  final Function PickDocument;
  final String imageKey;
  String? _imagePath;

  void detectObject() async{
    _imagePath=await EdgeDetection.detectEdge;
    print(_imagePath);
    PickDocument(_imagePath,imageKey);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.document_scanner_rounded,size: 30,color: Theme.of(context).primaryColorDark,),
      onPressed: detectObject,
    );
  }
}

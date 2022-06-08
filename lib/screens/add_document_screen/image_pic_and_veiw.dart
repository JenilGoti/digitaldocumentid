import 'dart:io';

import 'package:flutter/material.dart';

import '../../widget/pickers/document_scanner.dart';

class ImagePicAndView extends StatefulWidget {
  const ImagePicAndView({Key? key, required this.imageKey, required this.image, required this.PickDocument, required this.size}) : super(key: key);

  final String imageKey;
  final Map<String, dynamic> image;
  final Function PickDocument;
  final double size;


  @override
  State<ImagePicAndView> createState() => _ImagePicAndViewState();
}

class _ImagePicAndViewState extends State<ImagePicAndView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Container(
              height: (MediaQuery.of(context).size.width * widget.size)+10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(10),
                  image: widget.image[widget.imageKey]==null
                      ? null
                      : DecorationImage(
                      image: FileImage(File(widget.image[widget.imageKey].toString())), fit: BoxFit.fill)),
              child: Stack(
                children: [

                  if(widget.image[widget.imageKey]==null)
                  Center(child: Padding(
                    padding: const EdgeInsets.only(top: 25,right: 10,bottom: 10,left: 10),
                    child: Image.asset('assets/add_card.PNG',fit: BoxFit.cover,color: Theme.of(context).primaryColorLight,),
                  )),
                  DocumentScan(PickDocument: widget.PickDocument,imageKey: widget.imageKey,),
                  Align(alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Theme.of(context).primaryColorDark,Theme.of(context).accentColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(9),topLeft: Radius.circular(9))
                      ),
                      child: Text(widget.imageKey,textScaleFactor: 1.6,style: TextStyle(color: Colors.white),),
                    ),

                  ),

                ],
                alignment: Alignment.bottomRight,
              ),

            ),
          ],
        ),
      );

  }
}

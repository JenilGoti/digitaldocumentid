import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../documnts/document_list.dart';
import 'image_view.dart';
import 'veiw_widget.dart';

class ShowDocumentFild extends StatelessWidget {
  ShowDocumentFild({Key? key, required this.snapshot, required this.Id}) : super(key: key);
  final DocumentSnapshot snapshot;
  final String Id;

  var keys;

  Future<List> getKey()
  async {
    return await DocumentList().imageArrey(Id);
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: FutureBuilder(
        future: getKey(),
        builder: (context,snapshot2) {
          return snapshot2.connectionState!=ConnectionState.waiting?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Documents',
                textScaleFactor: 1.5,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              Divider(
                color: Theme.of(context).accentColor,
              ),

              ...(snapshot2.data as List).map((imageKey) {
                return ImageView(
                    image: snapshot['image'],
                    imageKey: imageKey,
                    size: snapshot['size'],
                    );
              }).toList(),
              ...snapshot['details'].keys.map((detailsKey) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      detailsKey,
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    Divider(
                      color: Theme.of(context).accentColor,
                    ),
                    ViewWidget(
                        details:snapshot['details'] ,
                        detailKey: detailsKey,
                    ),

                  ],
                );
              }).toList(),
              SizedBox(
                height: 50,
              ),
            ],
          ):const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}

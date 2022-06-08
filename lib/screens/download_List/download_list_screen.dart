import 'package:digitaldocumentid/Helper/DatabaseHelper.dart';
import 'package:digitaldocumentid/screens/download_List/get_logo_image.dart';
import 'package:digitaldocumentid/widget/drower.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class DownLoadList extends StatelessWidget {
  const DownLoadList({Key? key}) : super(key: key);

  openFile(filepath) async
  {
    try {
      OpenFile.open(filepath);
    }
    catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      drawer: DrowerWidget(),
      body: FutureBuilder(
        future: DatabaseHelper.instance.getAllDoc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('You have No Downloads'),
            );
          } else {

            return ListView.builder(
              itemBuilder: (context, index) {
                final docId=((snapshot.data as List)[index] as Map)['_id'];
                final docName=((snapshot.data as List)[index] as Map)['_name'];
                final filepath=((snapshot.data as List)[index] as Map)['_filepath'];

                return Dismissible(
                  key: ValueKey(docId),
                  background: Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction){
                    // return Future.value(false);
                    return showDialog(context: context, builder: (_){
                      return AlertDialog(
                        title: Text('Are you shore'),
                        content: Text('Do you want to remove the itom from the cart'),
                        actions: [
                          FlatButton(onPressed: (){
                            Navigator.of(context).pop(false);
                          }, child: Text('No')),
                          FlatButton(onPressed: (){
                            Navigator.of(context).pop(true);
                          }, child: Text('Yes')),
                        ],
                      );
                    });
                  },
                  onDismissed: (_) {
                    DatabaseHelper.instance.delete(docId);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        onTap: (){
                          openFile(filepath);
                          },
                        leading: GetLogoImage(docId: docId,),
                        title: Text(docName),
                      ),
                    ),
                  ),
                );

              },
              itemCount: (snapshot.data as List).length,
              // reverse: true,
            );
          }
        },
      ),
    );
  }
}



import 'dart:convert';

import 'package:digitaldocumentid/Helper/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../documnts/document_list.dart';

// class DownloadListTile extends StatefulWidget {
//   const DownloadListTile({Key? key, required this.docId, required this.docName,required this.filePath}) : super(key: key);
//   final String docId;
//   final String docName;
//   final filePath;
//
//
//
//   @override
//   State<DownloadListTile> createState() => _DownloadListTileState();
// }
//
// class _DownloadListTileState extends State<DownloadListTile> {
//
//
//
//

//
//
//   //   try {
//   //     final pdf = pw.Document();
//   //
//   //     final keys = await DocumentList().imageArrey(widget.docId);
//   //     for (String key in keys) {
//   //       final netImage = await networkImage(widget.images[key]);
//   //       pdf.addPage(pw.Page(build: (pw.Context context) {
//   //         return pw.Center(
//   //           child: pw.Image(netImage),
//   //         ); // Center
//   //       }));
//   //     }
//   //
//   //     final output = await getTemporaryDirectory();
//   //     final file = File(
//   //         '${output.path}/${FirebaseAuth.instance.currentUser!.uid}${widget.id}.pdf');
//   //     await file.writeAsBytes(await pdf.save());
//   // OpenFile.open(file.path);
//   //   setState(() {
//   // _lodding = false;
//   // });
//   // try {
//   // final dbInst = DatabaseHelper.instance;
//   // await dbInst.insert(dbInst.row(widget.id, widget.docName, file.path));
//   // } catch (e) {
//   // final dbInst = DatabaseHelper.instance;
//   // await dbInst.updateStatic( row: dbInst.row(widget.id, widget.docName, file.path) ,id: widget.id);
//   // print(e);
//   // }
//   //   } catch (e) {
//   // widget.ErrorSnackBar(e);
//   //
//   //
//   // setState(() {
//   // _lodding = false;
//   // });
//   // }
//
//
//
//
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }



class GetLogoImage extends StatefulWidget {
   GetLogoImage({
    Key? key, required this.docId,
  }) : super(key: key);
  final String docId;

  @override
  State<GetLogoImage> createState() => _GetLogoImageState();
}

class _GetLogoImageState extends State<GetLogoImage> {


  bool _isLodding=false;
  var image;
  getImage() async {
    setState(() {
      _isLodding = true;
    });
    try {
      final responce = await http.get(Uri.parse(
          'https://documentid-ed73f-default-rtdb.firebaseio.com/document_formates/${widget.docId}.json'));

      final docModel = jsonDecode(responce.body) as Map<String, dynamic>;
      image=docModel['logoimage'];


      setState(() {
        _isLodding = false;
      });
    } on http.ClientException catch (e) {

      setState(() {
        _isLodding = false;
      });
      print(e.message);
    }
  }
  initState(){
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: _isLodding?Image.asset('assets/add_card.PNG',color: Theme.of(context).accentColor.withOpacity(0.5),):Image.network(
        image,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}

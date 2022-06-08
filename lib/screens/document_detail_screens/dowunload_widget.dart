import 'dart:io';

import 'package:digitaldocumentid/Helper/DatabaseHelper.dart';
import 'package:digitaldocumentid/documnts/document_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';

class DownloadWidget extends StatefulWidget {
  const DownloadWidget(
      {Key? key,
      required this.images,
      required this.id,
      required this.docName,
      required this.ErrorSnackBar})
      : super(key: key);
  final Map<String, dynamic> images;
  final String id;
  final String docName;
  final Function ErrorSnackBar;

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  bool _lodding = false;

  DownloadAsPdf() async {
    setState(() {
      _lodding = true;
    });
    try {
      final pdf = pw.Document();

      final keys = await DocumentList().imageArrey(widget.id);
      for (String key in keys) {
        final netImage = await networkImage(widget.images[key]);
        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(netImage),
          ); // Center
        }));
      }

      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/${FirebaseAuth.instance.currentUser!.uid}${widget.id}.pdf');
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
      setState(() {
        _lodding = false;
      });
      try {
        final dbInst = DatabaseHelper.instance;
        await dbInst.insert(dbInst.row(widget.id, widget.docName, file.path));
      } catch (e) {
        final dbInst = DatabaseHelper.instance;
        await dbInst.updateStatic( row: dbInst.row(widget.id, widget.docName, file.path) ,id: widget.id);
        print(e);
      }
    } catch (e) {
      widget.ErrorSnackBar(e);


      setState(() {
        _lodding = false;
      });
    }

    print('download');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.download_rounded),
      onPressed: DownloadAsPdf,
    );
  }
}

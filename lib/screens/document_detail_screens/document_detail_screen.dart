import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/screens/document_detail_screens/dowunload_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'show_document_fild.dart';

class DocumentDetailScreen extends StatelessWidget {
  DocumentDetailScreen(
      {Key? key, required this.documentId, required this.docName})
      : super(key: key);
  final String documentId;
  final String docName;
  ErrorSnackBar(message)
  {
    _ScaffoldKey.currentState!.showSnackBar(SnackBar(content: message));
  }

  final _ScaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
            key: _ScaffoldKey,
                  appBar: AppBar(
                    title: Text(docName),

                  ),
                  floatingActionButton:DownloadWidget(
                    images: (snapshot.data as DocumentSnapshot)['image'],
                    id: documentId,
                    docName: docName,
                    ErrorSnackBar: ErrorSnackBar,

                  ),
                  body: ShowDocumentFild(
                    snapshot: (snapshot.data as DocumentSnapshot),
                    Id: documentId,
                  ));
        },
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('user_document_info')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('${documentId}')
            .doc('${FirebaseAuth.instance.currentUser!.uid}')
            .snapshots());
  }
}

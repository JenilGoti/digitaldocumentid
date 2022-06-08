import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/documnts/document_list.dart';
import 'package:digitaldocumentid/models/document_formate.dart';
import 'package:digitaldocumentid/screens/add_document_screen/add_document_screen.dart';
import 'package:digitaldocumentid/screens/document_detail_screens/document_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({
    Key? key,
    required this.doc,
  }) : super(key: key);
  final DocumentFormat doc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GridTile(
        footer: Container(
          padding: EdgeInsets.only(right: 8),
          alignment: Alignment.centerRight,
          height: 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
          ),
          child: Text(
            doc.name,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start,
            textScaleFactor: 1.3,
            style: TextStyle(color: Colors.white),
          ),
        ),
        header: Container(
          height: 0,
          width: 0,
          alignment: Alignment.topRight,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc('${FirebaseAuth.instance.currentUser!.uid}')
                .collection('user_documentList')
                .doc('${doc.id}')
                .snapshots(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(),
                      )
                    : IconButton(
                        tooltip: !(snapshot.data as DocumentSnapshot).exists
                            ? 'Click To Add Document'
                            : (snapshot.data as DocumentSnapshot)[
                                        'verification_status'] ==
                                    0
                                ? 'verified'
                                : (snapshot.data as DocumentSnapshot)[
                                            'verification_status'] ==
                                        1
                                    ? 'Rejected'
                                    : (snapshot.data as DocumentSnapshot)[
                                                'verification_status'] ==
                                            2
                                        ? 'In Progress'
                                        : 'UnKnown',
                        onPressed: () {},
                        icon: !(snapshot.data as DocumentSnapshot).exists
                            ? const Icon(
                                Icons.error,
                                color: Colors.red,
                              )
                            : (snapshot.data as DocumentSnapshot)[
                                        'verification_status'] ==
                                    0
                                ? const Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  )
                                : (snapshot.data as DocumentSnapshot)[
                                            'verification_status'] ==
                                        1
                                    ? const Icon(
                                        Icons.close_outlined,
                                        color: Colors.red,
                                      )
                                    : (snapshot.data as DocumentSnapshot)[
                                                'verification_status'] ==
                                            2
                                        ? const Icon(
                                            Icons.access_time_rounded,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                          ),
                      ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22.0),
          child: GestureDetector(
            onTap: () async {
              final avDoc = await DocumentList().AvailableDocumentId();
              if (avDoc.contains(doc.id)) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DocumentDetailScreen(
                    documentId: doc.id,
                    docName: doc.name,
                  ),
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddDocumentScreen(documentId: doc.id),
                ));
              }
            },
            child: doc.image.contains('https')
                ? Image.network(
                    doc.image,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.low,
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
                  )
                : Image.asset(
                    doc.image,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}

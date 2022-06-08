import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/models/document_formate.dart';
import 'package:digitaldocumentid/widget/drower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../documnts/document_list.dart';
import '../add_document_screen/add_document_screen.dart';
import '../document_detail_screens/document_detail_screen.dart';

class AllDocumentListScreen extends StatefulWidget {
  AllDocumentListScreen({Key? key}) : super(key: key);

  @override
  State<AllDocumentListScreen> createState() => _AllDocumentListScreenState();
}

class _AllDocumentListScreenState extends State<AllDocumentListScreen> {
  List<DocumentFormat> _allDocument = [];
  bool _isLodding = false;

  getAllDocument() async {
    setState(() {
      _isLodding = true;
    });
    try {
      final responce = await http.get(Uri.parse(
          'https://documentid-ed73f-default-rtdb.firebaseio.com/document_formates.json'));

      final docModel = jsonDecode(responce.body) as Map<String, dynamic>;

      docModel.keys.forEach((key) {
        final value = docModel[key];
        _allDocument.add(DocumentFormat(
            name: value['name'],
            id: key,
            image: value['logoimage'],
            category: Category.unrequited));
      });

      setState(() {
        _isLodding = false;
      });
    } on http.ClientException catch (e) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message)));
      print(e.message);
    }
    print(_allDocument);
  }

  initState() {
    super.initState();
    getAllDocument();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Document List'),
      ),
      drawer: DrowerWidget(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    _allDocument[index].image,
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
                ),
                title: Text(
                  _allDocument[index].name,
                  textScaleFactor: 1.01,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc('${FirebaseAuth.instance.currentUser!.uid}')
                        .collection('user_documentList')
                        .doc('${_allDocument[index].id}')
                        .snapshots(),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Row(
                            children: const [
                              Text(
                                'Document Status:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Lodding'),
                            ],
                          )
                        : !(snapshot.data as DocumentSnapshot).exists
                            ? Text('Click To Add This Document')
                            : Row(
                                children: [
                                  const Text(
                                    'Document Status:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (VerificationStatus.verified.index ==
                                      ((snapshot.data as DocumentSnapshot)[
                                          'verification_status']))
                                    Text(VerificationStatus.verified.name),
                                  if (VerificationStatus.rejected.index ==
                                      ((snapshot.data as DocumentSnapshot)[
                                          'verification_status']))
                                    Text(VerificationStatus.rejected.name),
                                  if (VerificationStatus.inProgress.index ==
                                      ((snapshot.data as DocumentSnapshot)[
                                          'verification_status']))
                                    Text(VerificationStatus.inProgress.name),
                                  if (VerificationStatus.unknown.index ==
                                      ((snapshot.data as DocumentSnapshot)[
                                          'verification_status']))
                                    Text(VerificationStatus.unknown.name)
                                ],
                              )),
                onTap: () async {
                  final avDoc = await DocumentList().AvailableDocumentId();
                  if (avDoc.contains(_allDocument[index].id)) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DocumentDetailScreen(
                        documentId: _allDocument[index].id,
                        docName: _allDocument[index].name,
                      ),
                    ));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddDocumentScreen(documentId: _allDocument[index].id),
                    ));
                  }
                }),
          );
        },
        itemCount: _allDocument.length,
      ),
    );
  }
}

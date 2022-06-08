import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/models/document_formate.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

class DocumentList{
  List<DocumentFormat> _list = [
    DocumentFormat(
        name: 'Aadhar Card',
        id: 'd1',
        image: 'assets/Aadhaar_Logo.png',
        category: Category.required),
    DocumentFormat(
        name: 'PAN Card',
        id: 'd2',
        image: 'assets/PAN_logo.png',
        category: Category.required),
    DocumentFormat(
        name: 'Voter ID',
        id: 'd3',
        image: 'assets/eci-logo.png',
        category: Category.required),
    DocumentFormat(
        name: 'Ration Card',
        id: 'd4',
        image: 'assets/retion_card.png',
        category: Category.required),
  ];

   Future<List<DocumentFormat>> documents() async {
     await addDocument().whenComplete(() {
       print('completed');
    });
     return _list;


  }

  Future<void> addDocument() async {

      print('abc');
      final _auth = FirebaseAuth.instance;

      final UserData = await FirebaseFirestore.instance
          .collection('user')
          .doc('${_auth.currentUser!.uid}')
          .collection('user_details')
          .doc('${_auth.currentUser!.uid}')
          .get();
      final anotherDoc = (UserData['addedDocuments']).where((element) {
        return element[1].toString().compareTo('4') > 0;
      });
      print(anotherDoc);
      for (var element in anotherDoc) {
        final response = await http.get(Uri.parse(
            'https://documentid-ed73f-default-rtdb.firebaseio.com/document_formates/$element.json'));

        final decodedResponce =
            jsonDecode(response.body) as Map<String, dynamic>;
        final document = DocumentFormat(
            name: decodedResponce['name'],
            id: element,
            image: decodedResponce['logoimage'],
            category: Category.unrequited);

        _list.add(document);
        print(_list);
      }

  }


  Future<List> AvailableDocumentId()
  async {
    final auth = FirebaseAuth.instance;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('user_details')
        .doc(auth.currentUser!.uid)
        .get();
    final anotherDoc =
    (userData['addedDocuments']);
    return anotherDoc;
  }

  Future<List<dynamic>> imageArrey(String id)
  async {
    final response = await http.get(Uri.parse(
        'https://documentid-ed73f-default-rtdb.firebaseio.com/document_formates/$id/image.json'));
    return jsonDecode(response.body);

  }

}

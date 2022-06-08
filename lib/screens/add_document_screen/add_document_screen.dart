import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/documnts/document_list.dart';
import 'package:digitaldocumentid/models/document_formate.dart';
import 'package:digitaldocumentid/screens/add_document_screen/image_pic_and_veiw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'editing_widget.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({Key? key, required this.documentId})
      : super(key: key);
  final String documentId;

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  bool _loadding = false;
  Map<String, dynamic> docModel = {};
  List docItomList = [];
  double size = 0.627952;
  Map<String, dynamic> details = {};

  Map<String, dynamic> userDetails = {};

  Map<String, dynamic> _image = {};

  Future<void> setDataModel() async {
    docModel.forEach((key, value) {
      if (key == 'image') {
        (value as List).forEach((element) {
          _image.addAll({element: null});
        });
      }
      if (key == 'size') {
        size = value;
      }
      if (key == 'details') {
        details = value;
        userDetails = new Map<String, dynamic>.from(value);
      }
    });
  }

  saveDetailValue(detailKey, keyValue) {
    userDetails[detailKey] = keyValue;
  }

  Future<void> getDate() async {
    setState(() {
      _loadding = true;
    });
    try {
      final responce = await http.get(Uri.parse(
          'https://documentid-ed73f-default-rtdb.firebaseio.com/document_formates/${widget.documentId}.json'));

      docModel = jsonDecode(responce.body) as Map<String, dynamic>;
      setDataModel();
      print(docModel);
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      _loadding = false;
    });
  }

  initState() {
    getDate();
  }

  PickDocument(image, key) {
    setState(() {
      _image[key] = image;
    });
  }

  Submit() async {
    FocusScope.of(context).unfocus();
    final validation = _formKey.currentState!.validate();

    if (!validation) {
      return;
    }
    if (_image.values.contains(null)) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text('Please Enter all Images')));
      return;
    }
    if (userDetails.values.contains('Date')) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text('Please Select Date')));
      return;
    }
    try {
      setState(() {
        _loadding = true;
      });

      final _auth = FirebaseAuth.instance;
      final _fireStore = FirebaseFirestore.instance;
      _image.keys.forEach((imageKey) async {
        final ref = await FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${_auth.currentUser!.uid}')
            .child('user_document')
            .child(widget.documentId)
            .child(imageKey);

        await ref.putFile(File(_image[imageKey]));
        _image[imageKey] = await ref.getDownloadURL();

        print(_image[imageKey]);
        print(imageKey);
        print(_image.keys.last);

        if (_image.values
            .where((element) => !element.toString().contains('https'))
            .isEmpty) {
          print(_image);
          await FirebaseFirestore.instance
              .collection('user')
              .doc('${_auth.currentUser!.uid}')
              .collection('user_document_info')
              .doc('${_auth.currentUser!.uid}')
              .collection('${widget.documentId}')
              .doc('${_auth.currentUser!.uid}')
              .set({
            "name": docModel['name'],
            "size": docModel['size'],
            "image": _image,
            "details": userDetails
          }).whenComplete(() {
            _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content:
                    Text('Your Document Has Been Success Fully Uplodede')));
          });
          await FirebaseFirestore.instance
              .collection('user')
              .doc('${_auth.currentUser!.uid}')
              .collection('user_documentList')
              .doc('${widget.documentId}')
              .set({
            "name": docModel['name'],
            "verification_status": VerificationStatus.inProgress.index,
            "request_time": DateTime.now().toIso8601String(),
          }).whenComplete(() async {
            final UserData = await DocumentList().AvailableDocumentId();
            UserData.add(widget.documentId);

            await FirebaseFirestore.instance
                .collection('user')
                .doc('${_auth.currentUser!.uid}')
                .collection('user_details')
                .doc('${_auth.currentUser!.uid}')
                .set({
              "addedDocuments": UserData,
            }, SetOptions(merge: true)).whenComplete(() {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content:
                      Text('Your Request For Verification Has Been sended')));

              Future.delayed(
                Duration(seconds: 3),
                () => Navigator.of(_scaffoldKey.currentContext as BuildContext)
                    .pop(),
              );
            });
          });
        }
      });
    } on FirebaseException catch (e) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      setState(() {
        _loadding = false;
      });
    } catch (e) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _loadding = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Add your ${docModel['name']} detail'),
            ),
            body:_loadding
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DocumentFilds(context),
              ),
            ),
          );
  }

  Widget DocumentFilds(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            'Add Images Below',
            textScaleFactor: 1.5,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          ..._image.keys.map((imageKey) {
            return ImagePicAndView(
              image: _image,
              imageKey: imageKey,
              PickDocument: PickDocument,
              size: size,
            );
          }).toList(),
          ...details.keys.map((detailsKey) {
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
                EditingWidget(
                    details: details,
                    detailKey: detailsKey,
                    saveData: saveDetailValue),
              ],
            );
          }).toList(),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: Submit,
              child: Text("Submit Data"),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/screens/home_screen/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/user_detail_edit.dart';

class InitialUserDetailScreen extends StatefulWidget {
  const InitialUserDetailScreen({Key? key}) : super(key: key);

  @override
  State<InitialUserDetailScreen> createState() =>
      _InitialUserDetailScreenState();
}

class _InitialUserDetailScreenState extends State<InitialUserDetailScreen> {
  final _auth = FirebaseAuth.instance;
  final _FireStore = FirebaseFirestore.instance;
  bool _isLodding = false;

  _submitData(
      {required String userFname,
      required String userLastName,
      required String useMiddleName,
      required String userGender,
      required DateTime usaeDOB,
      required String userAadharNo,
      required XFile userCurrentImage,
      required String userEmail,
      required Address userAddress}) async {
    try {
      setState(() {
        _isLodding = true;
      });

      final ref = await FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${_auth.currentUser!.uid}')
          .child('user_photo')
          .child('${_auth.currentUser!.uid}');
      await ref.putFile(File(userCurrentImage.path));
      final userDownloadUrl = await ref.getDownloadURL();

      await _auth.currentUser!.updateDisplayName('$userFname  $userLastName');
      await _auth.currentUser!.updateEmail(userEmail);
      await _auth.currentUser!.updatePhotoURL(userDownloadUrl);

      await _FireStore.collection('user')
          .doc('${_auth.currentUser!.uid}')
          .collection('user_details')
          .doc('${_auth.currentUser!.uid}')
          .set({
        'addedDocuments': [],
        'userFname': userFname,
        'userLastName': userLastName,
        'useMiddleName': useMiddleName,
        'gender': userGender,
        'usaeDOB': usaeDOB.toIso8601String(),
        'userAadharNo': userAadharNo,
        'userCurrentImage': userDownloadUrl,
        'userEmail': userEmail,
        'userAddress': jsonEncode({
          'ploatNo': userAddress.ploatNo,
          'addressName': userAddress.addressName,
          'addressByNear': userAddress.addressByNear,
          'village': userAddress.village,
          'city': userAddress.city,
          'contry': userAddress.contry,
          'state': userAddress.state,
          'PINcode': userAddress.PINcode,
        }),
      });
      _key.currentState!.showSnackBar(
          SnackBar(content: Text('Your Data has bin Sucessfully submitted')));
      Navigator.of(_key.currentContext as BuildContext)
          .pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
      print('scessfull');
      setState(() {
        _isLodding = false;
      });
    } on FirebaseException catch (e) {
      _key.currentState!.showSnackBar(
          SnackBar(content: Text(e.message.toString().toUpperCase())));
      setState(() {
        _isLodding = false;
      });

      print(e);
      // TODO
    }
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLodding == true
          ? Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: UserDetailForm(
                    submitdata: _submitData,
                    isInitialScreen: true,
                  ),
                ),
              ),
            ),
    );
  }
}

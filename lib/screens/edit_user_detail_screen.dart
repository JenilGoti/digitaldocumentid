import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/address.dart';
import '../widget/user_detail_edit.dart';

class EditUserDetailScreen extends StatelessWidget {
  EditUserDetailScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _FireStore = FirebaseFirestore.instance;

  _submitData(
      {required String userFname,
      required String userLastName,
      required String useMiddleName,
      required String userGender,
      required DateTime usaeDOB,
      required String userAadharNo,
      required XFile? userCurrentImage,
      required String userEmail,
      required Address userAddress}) async {
    try {
      String userDownloadUrl;
      if (userCurrentImage != null) {
        final ref = await FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${_auth.currentUser!.uid}')
            .child('user_photo')
            .child('${_auth.currentUser!.uid}');
        ref.putFile(File(userCurrentImage.path));
        userDownloadUrl = await ref.getDownloadURL();
      } else {
        userDownloadUrl = _auth.currentUser!.photoURL!;
      }

      await _auth.currentUser!.updateDisplayName('$userFname  $userLastName');
      await _auth.currentUser!.updateEmail(userEmail);
      await _auth.currentUser!.updatePhotoURL(userDownloadUrl);

      await _FireStore.collection('user')
          .doc('${_auth.currentUser!.uid}')
          .collection('user_details')
          .doc('${_auth.currentUser!.uid}')
          .set({
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
      }, SetOptions(merge: true));

        _key.currentState!.showSnackBar(
            SnackBar(content: Text('Your Data has bin Sucessfully Updated'),
            ),

        );

        Future.delayed(Duration(seconds: 3),() => Navigator.of(_key.currentContext as BuildContext).pop(),);




      print('scessfull');
    } on FirebaseException catch (e) {
      _key.currentState!.showSnackBar(
          SnackBar(content: Text(e.message.toString().toUpperCase())));

      print(e);
      // TODO
    }

  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Profile'),
      ),
      key: _key,
      body: Center(
        child: SingleChildScrollView(
          child: UserDetailForm(
            submitdata: _submitData,
            isInitialScreen: false,
          ),
        ),
      ),
    );
  }
}

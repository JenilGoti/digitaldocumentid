import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GetUserTokans{
  
  static GetUserTokans instance =GetUserTokans(users: []);
  
  
  final List<String> users;
  GetUserTokans({required this.users});


}



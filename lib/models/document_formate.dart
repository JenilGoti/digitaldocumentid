import 'package:flutter/material.dart';

enum Category { required, unrequited }
enum VerificationStatus {verified,rejected,inProgress,unknown}

class DocumentFormat {
  final String name;
  final String id;
  final String image;
  final Category category;
  final VerificationStatus verSts;

  DocumentFormat({
    required this.name,
    required this.id,
    required this.image,
    required this.category,
    this.verSts=VerificationStatus.unknown,
  });
}

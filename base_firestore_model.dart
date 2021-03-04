import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseFirestoreModel {
  DocumentReference _ref;
  DocumentReference get reference => _ref;

  @protected
  set id(String docId);

  String get id;

  @mustCallSuper
  BaseFirestoreModel.fromSnapshot(DocumentSnapshot snapshot) {
    _ref = snapshot.reference;
    id = snapshot.documentID;
  }

  BaseFirestoreModel.create(DocumentReference reference) {
    _ref = reference;
    id = reference.documentID;
  }

  int get hash => toMap().hashCode;

  @mustCallSuper
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = id;
    return map;
  }
}

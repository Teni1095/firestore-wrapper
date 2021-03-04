import 'package:cloud_firestore/cloud_firestore.dart';

import 'base_firestore_model.dart';

abstract class BaseFirestoreRepository<T extends BaseFirestoreModel> {
  Future<void> addToFirestore(T model,
      {bool checkBeforeAdd = true,
      Transaction transaction,
      WriteBatch batch}) async {
    if (checkBeforeAdd ? !await checkIfDocExists(model) : true) {
      if (transaction != null) {
        await transaction?.set(model.reference, model.toMap());
      } else if (batch != null) {
        batch?.setData(model.reference, model.toMap());
      } else {
        await model.reference.setData(model.toMap());
      }
    }
  }

  CollectionReference get collectionReference;
  Future<void> deleteFromFirestore(T model,
      {Transaction transaction, WriteBatch batch}) async {
    transaction?.delete(model.reference) ?? batch?.delete(model.reference);
  }

  Future<bool> checkIfDocExists(T model) async {
    CollectionReference collRef = model.reference.parent();
    Map<String, dynamic> map = model.toMap();
    map.remove("id");

    Query query = collRef.where(map.keys.toList()[0],
        isEqualTo: map[map.keys.toList()[0]]);

    map.remove(map.keys.toList()[0]);

    for (var key in map.keys) {
      query = query.where(key, isEqualTo: map[key]);
    }
    var doc = await query.getDocuments();
    return doc.documents.isNotEmpty;
  }

  Future<DocumentSnapshot> getSnapshot(Map<String, dynamic> map) async {
    Query query = getQuery(collectionReference, map);
    var docs = await query.getDocuments();
    if (docs.documents.isNotEmpty) {
      var snapshot = docs.documents.first;
      return snapshot;
    }
    return null;
  }

  Future<T> getModel(Map<String, dynamic> map);

  Query getQuery(
      CollectionReference collectionReference, Map<String, dynamic> map) {
    Query query = collectionReference.where(map.keys.toList()[0],
        isEqualTo: map[map.keys.toList()[0]]);

    map.remove(map.keys.toList()[0]);

    for (var key in map.keys) {
      query = query.where(key, isEqualTo: map[key]);
    }
    return query;
  }
}

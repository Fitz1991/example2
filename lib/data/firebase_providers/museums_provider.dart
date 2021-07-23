import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/domain/search/algolia.dart';
import 'package:veterans/model/museums/museum.dart';

class MuseumsProvider {
  final museumTable = Firestore.instance.collection('museums');
  final Algolia _algoliaApp = AlgoliaApplication.algolia;

  Stream<List<Museum>> museums() {
    return museumTable.snapshots().map((snapshot) {
      return snapshot.documents
          .map((snapshot) => Museum.fromSnapshot(snapshot))
          .toList();
    });
  }

  Stream<Museum> museum(String documentID) {
    return museumTable.document(documentID).snapshots().map((doc) {
      return Museum.fromSnapshot(doc);
    });
  }

  Stream<List<Museum>> searchMuseumsByFullName(String text) async* {
    AlgoliaQuery query = _algoliaApp.instance.index('museums').search(text);
    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
    yield querySnapshot.hits
        .map((doc) => Museum.fromAlgoliaSnapshot(doc))
        .toList();
  }
}

import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/domain/search/algolia.dart';
import 'package:veterans/model/veterans/veteran.dart';

class VeteransProvider {
  final String collection;
  CollectionReference _veteranTable;
  Algolia _algoliaApp;

  VeteransProvider() : collection = 'veterans' {
    _veteranTable = Firestore.instance.collection(collection);
    _algoliaApp = AlgoliaApplication.algolia;
  }

  // snapshot.documents.map((doc) => Veteran.fromSnapshot(doc)).toList();

  Stream<QuerySnapshot> veterans({int limit,DocumentSnapshot startAfter}) {
    if(limit != null){
      final refVeterans = _veteranTable.orderBy('surname').limit(limit);
      if (startAfter == null) {
        return refVeterans.snapshots();
      } else {
        return refVeterans.startAfterDocument(startAfter).snapshots();
      }
    } else{
      return _veteranTable.orderBy('surname').snapshots();
    }
  }

  Stream<T> veteran<T>(String path) {
    return _veteranTable.document(path).snapshots().map((doc) {
      return Veteran.fromSnapshot(doc) as T;
    });
  }

  Future<AlgoliaQuerySnapshot> searchVeteransByFullName(String text,
      {int page}) async {
    AlgoliaQuery query;
    if (page == null) {
      query = _algoliaApp.instance.index(collection).search(text);
    } else {
      query = _algoliaApp.instance.index(collection).search(text).setPage(page);
    }
    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
    return querySnapshot;
    // yield querySnapshot.hits.map((doc) => Veteran.fromAlgoliaSnapshot(doc)).toList();
  }

  Stream<QuerySnapshot> veteransWithGeocode() {
    return _veteranTable
        .orderBy('geocode')
        .snapshots();
  }
}

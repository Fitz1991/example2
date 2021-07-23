import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/data/firebase_providers/veterans_firestore_provider.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';

import '../algolia_repository.dart';

class FirestoreVeteransRepository implements VeteranRepository, AlgoliaRepository {
  final VeteransProvider _veteransProvider;

  FirestoreVeteransRepository(this._veteransProvider);

  Stream<Output> veterans<Output, SA>({int limit, SA startAfter}) {
    var veterans = _veteransProvider.veterans(limit: limit,
        startAfter: (startAfter as DocumentSnapshot));
    return veterans as Stream<Output>;
  }

  Stream<T> veteran<T>(String documentId) {
    return _veteransProvider.veteran(documentId);
  }

  Future<AlgoliaQuerySnapshot> searchByFullName(String text, {int page}) {
    return _veteransProvider.searchVeteransByFullName(text, page: page);
  }

  @override
  Stream<T> createVeteran<T, Data>(Data veteranData) {
    // TODO: implement createVeteran
  }

  @override
  Stream<Output> veteransWithGeocode<Output>() {
    return _veteransProvider.veteransWithGeocode() as Stream<Output>;
  }

}

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/data/resources.dart';
import 'package:veterans/model/veterans/veteran.dart';

class VeteransUpdatedAdapter{
  bool hasNext = true;

  T getSnapshot <T>(){}

  List<Veteran> get veterans{}
}

class AlgoliaVeteransUpdatedAdapter implements VeteransUpdatedAdapter{
  AlgoliaQuerySnapshot veteransSnapshot;
  String text;
  int page;

  AlgoliaVeteransUpdatedAdapter({this.veteransSnapshot, this.text, this.page}){
    if(veteransSnapshot.hits.length < veteransPageSize) hasNext = false;
  }

  @override
  List<Veteran> get veterans {
   return veteransSnapshot.hits.map((doc) => Veteran.fromAlgoliaSnapshot(doc)).toList();
  }

  @override
  T getSnapshot<T>() {
    return veteransSnapshot as T;
  }

  @override
  bool hasNext = true;
}


class FirebaseVeteransUpdatedAdapter implements VeteransUpdatedAdapter{

  QuerySnapshot veteransSnapshot;
  FirebaseVeteransUpdatedAdapter({this.veteransSnapshot}){
    if(veteransSnapshot.docs.length < veteransPageSize) hasNext = false;
  }

  @override
  List<Veteran> get veterans {
    return veteransSnapshot.docs.map((doc) => Veteran.fromSnapshot(doc)).toList()
        .toList();
  }

  @override
  T getSnapshot<T>() {
    return veteransSnapshot as T;
  }

  @override
  bool hasNext = true;
}
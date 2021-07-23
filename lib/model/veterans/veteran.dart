import 'dart:typed_data';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/model/address.dart';
import 'package:veterans/model/veterans/years_in_army.dart';
import 'package:veterans/model/veterans/youtube_link.dart';

import '../story.dart';
import 'geocode.dart';

class Veteran {
  Veteran({
    this.id,
    this.surname,
    this.fio,
    this.pdfFile,
    this.secondName,
    this.firstName,
    this.birthday,
    this.birthIsOnlyYear,
    this.deathIsOnlyYear,
    this.deathDate,
    this.yearOfBirth,
    this.yearOfDeath,
    this.yearsOld,
    this.placeOfBirth,
    this.burialPlace,
    this.militaryRank,
    this.yearsInArmy,
    this.address,
    this.story,
    this.images,
    this.youtubeLinks,
    this.honors,
    this.geocode
  });

  String id;
  Uint8List pdfFile;
  String surname;
  String fio;
  String secondName;
  String firstName;
  DateTime birthday;
  bool birthIsOnlyYear;
  bool deathIsOnlyYear;
  DateTime deathDate;
  String yearOfBirth;
  String yearOfDeath;
  String yearsOld;
  Address placeOfBirth;
  Address burialPlace;
  String militaryRank;
  YearsInArmy yearsInArmy;
  Address address;
  List<Story> story;
  List<String> images;
  List<String> honors;
  List<YoutubeLink> youtubeLinks;
  Geocode geocode;


  Map<String, dynamic> toJson() =>
      {
        "surname": surname,
        "secondName": secondName,
        "firstName": firstName,
        "birthday": birthday.toUtc(),
        "deathDate": (deathDate != null) ? deathDate.toUtc() : null,
        "birthIsOnlyYear": birthIsOnlyYear,
        "deathIsOnlyYear": deathIsOnlyYear,
        "placeOfBirth": placeOfBirth.toJson(),
        "burialPlace": (burialPlace != null) ? burialPlace.toJson() : null,
        "militaryRank": militaryRank,
        "yearsInArmy": yearsInArmy.toJson(),
        "address": address.toJson(),
        "geocode": geocode.toJson(),
        "story": List<dynamic>.from(story.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x)),
        "youtubeLinks": List<dynamic>.from(youtubeLinks.map((x) => x.toJson())),
      };

  Veteran.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data();
    id = snap.documentID;
    firstName = data['firstName'];
    surname = data['surname'];
    secondName = data['secondName'];
    birthday = (data['birthday'] != null) ? data['birthday'].toDate() : null;
    deathDate = (data['deathDate'] != null) ? data['deathDate'].toDate(): null;
    birthIsOnlyYear = (data['birthIsOnlyYear'] != null) ? data['birthIsOnlyYear'] : null;
    deathIsOnlyYear = (data['deathIsOnlyYear'] != null) ? data['deathIsOnlyYear'] : null;
    yearOfBirth = _getBirthdayYear(birthday);
    yearOfDeath = _getDeathYear(deathDate);
    yearsOld = _getYearsOld(birthday, deathDate);
    fio = _getFio();
    militaryRank = data['militaryRank'];
    images = (data['images'] != null) ? List<String>.from(data['images'].map((x) => x)) : "" ;
    honors = (data['honors'] != null) ? List<String>.from(data['honors'].map((x) => x)) : "" ;
    placeOfBirth = Address.fromJson(data['placeOfBirth']);
    burialPlace = (data['burialPlace'] != null) ? Address.fromJson(data['burialPlace']) : null;
    yearsInArmy = YearsInArmy.fromJson(data["yearsInArmy"]);
    address = (data["address"] != null) ? Address.fromJson(data["address"]) : null;
    geocode = (data["geocode"] != null) ? Geocode.fromJson(data["geocode"]) : null;
    story = (data["story"] != null) ? List<Story>.from(data["story"].map((x) {
      return Story.fromJson(x);
    })) : null;
    youtubeLinks = (data["youtubeLinks"] != null) ? List<YoutubeLink>.from(
        data["youtubeLinks"].map((x) {
          return YoutubeLink.fromJson(x);
        })) : null;
  }

  Veteran.fromAlgoliaSnapshot(AlgoliaObjectSnapshot snap) {
    id = snap.objectID;
    firstName = snap.data['firstName'];
    surname = snap.data['surname'];
    secondName = snap.data['secondName'];
    birthday = (snap.data['birthday'] != null) ? Timestamp(snap.data['birthday']['_seconds'], snap.data['birthday']['_nanoseconds']).toDate() : null;
    deathDate = (snap.data['deathDate'] != null) ? Timestamp(snap.data['deathDate']['_seconds'], snap.data['deathDate']['_nanoseconds']).toDate(): null;
    yearOfBirth = _getBirthdayYear(birthday);
    yearOfDeath = _getDeathYear(deathDate);
    yearsOld = _getYearsOld(birthday, deathDate);
    fio = _getFio();
    militaryRank = snap.data['militaryRank'];
    images = (snap.data['images'] != null) ? List<String>.from(snap.data['images'].map((x) => x)) : "" ;
    honors = (snap.data['honors'] != null) ? List<String>.from(snap.data['honors'].map((x) => x)) : "" ;
    placeOfBirth = Address.fromJson(snap?.data['placeOfBirth']);
    burialPlace = (snap.data['burialPlace'] != null) ? Address.fromJson(snap.data['burialPlace']) : null;
    yearsInArmy = YearsInArmy.fromAlgoliaSnap(snap);
    address = (snap.data["address"] != null) ?  Address.fromJson(snap.data["address"]) : null;
    geocode = (snap.data["geocode"] != null) ?  Geocode.fromJson(snap.data["geocode"]) : null;
    story = List<Story>.from(snap.data["story"].map((x) => Story.fromJson(x))).toList();
    youtubeLinks = (snap.data["youtubeLinks"] != null) ? List<YoutubeLink>.from(
        snap.data["youtubeLinks"].map((x) => YoutubeLink.fromJson(x))).toList() : null;
  }

  String _getBirthdayYear(DateTime birthday) {
    if (birthday != null) {
      return "${birthday.year}";
    } else {
      return "";
    }
  }

  String _getDeathYear(DateTime deathDate) {
    if (deathDate != null) {
      return "-${deathDate.year}";
    } else {
      return "";
    }
  }

  String _getYearsOld(DateTime birthday, DateTime deathDate) {
    var yearsOld = 0;
    if (birthday != null) {
      if (deathDate != null) {
        yearsOld = deathDate.year - birthday.year;
        return "($yearsOld)";
      } else {
        return "-н.в";
      }
    } else
      return "";
  }

   String _getFio(){
     return '$surname ${firstName.substring(0, 1)}. ${secondName.substring(0, 1)}';
   }

}

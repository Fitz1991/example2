import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/model/address.dart';
import 'package:veterans/model/story.dart';

class Museum {

  Museum({
    this.id,
    this.name,
    this.images,
    this.introDesc,
    this.fullDesc,
    this.email,
    this.phone,
    this.address,
    this.stories,
  });

  String id;
  String name;
  List<String> images;
  String introDesc;
  String fullDesc;
  String email;
  String phone;
  Address address;
  List<Story> stories;

  factory Museum.fromJson(Map<String, dynamic> json) => Museum(
        id: json["id"],
        name: json["name"],
        images: List<String>.from(json["images"].map((x) => x)),
        introDesc: json["intro_desc"],
        fullDesc: json["full_desc"],
        email: json["email"],
        phone: json["phone"],
        address: Address.fromJson(json["address"]),
        stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x)),
        "intro_desc": introDesc,
        "full_desc": fullDesc,
        "email": email,
        "phone": phone,
        "address": address.toJson(),
        "history": List<dynamic>.from(stories.map((x) => x)),
      };

  Museum.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data();
    id = snap.documentID;
    name = data['name'];
    images = List<String>.from(data['images'].map((x) => x));
    introDesc = data['introDesc'];
    fullDesc = data['fullDesc'];
    email = data['email'];
    phone = data['phone'];
    address = Address.fromJson(data['address']);
    stories = (data["stories"] != null) ? List<Story>.from(data["stories"].map((x) => Story.fromJson(x))) : null;
  }

  Museum.fromAlgoliaSnapshot(AlgoliaObjectSnapshot snap) {
    id = snap.objectID;
    name = snap.data['name'];
    images = List<String>.from(snap.data['images'].map((x) => x));
    introDesc = snap.data['introDesc'];
    fullDesc = snap.data['fullDesc'];
    email = snap.data['email'];
    phone = snap.data['phone'];
    address = Address.fromJson(snap.data['address']);
    stories = (snap.data["stories"] != null) ? List<Story>.from(snap.data["stories"].map((x) => Story.fromJson(x))) : null;
  }
}



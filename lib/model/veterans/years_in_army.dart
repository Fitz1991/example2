import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YearsInArmy {
  YearsInArmy({
    this.start,
    this.end,
    this.yearsInArmyStartIsOnlyYear,
    this.yearsInArmyEndIsOnlyYear
  });

  DateTime start;
  DateTime end;
  bool yearsInArmyStartIsOnlyYear;
  bool yearsInArmyEndIsOnlyYear;

  factory YearsInArmy.fromJson(Map<String, dynamic> json) => YearsInArmy(
    start: json["start"].toDate(),
    end: json["end"].toDate(),
    yearsInArmyStartIsOnlyYear : json["yearsInArmyStartIsOnlyYear"],
    yearsInArmyEndIsOnlyYear : json["yearsInArmyEndIsOnlyYear"],
  );

  factory YearsInArmy.fromAlgoliaSnap(AlgoliaObjectSnapshot snap) => YearsInArmy(
    start: Timestamp(snap.data['yearsInArmy']['start']['_seconds'], snap.data['yearsInArmy']['start']['_nanoseconds']).toDate(),
    end: Timestamp(snap.data['yearsInArmy']['end']['_seconds'], snap.data['yearsInArmy']['end']['_nanoseconds']).toDate(),
  );

  Map<String, dynamic> toJson() => {
    "start": start.toIso8601String(),
    "end": end.toIso8601String(),
    "yearsInArmyStartIsOnlyYear" : yearsInArmyStartIsOnlyYear,
    "yearsInArmyEndIsOnlyYear" : yearsInArmyEndIsOnlyYear
  };
}
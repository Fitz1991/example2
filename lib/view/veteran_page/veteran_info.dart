import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veterans/data/firebase_providers/veterans_firestore_provider.dart';
import 'package:veterans/data/repositories/veterans/firestore_veterans_repository.dart';
import 'package:veterans/domain/maps/map_bloc.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/model/veterans/veteran_info_arguments.dart';

class VeteranInfo extends StatelessWidget {
  Veteran veteran;

  VeteranInfo({this.veteran});

  Widget deathDate(BuildContext context) {
    if (veteran.deathDate != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Умер: ',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: (veteran.deathIsOnlyYear == null || !veteran.deathIsOnlyYear)
                ? Text(
                    '${veteran.deathDate.day}.${veteran.deathDate.month}.${veteran.deathDate.year}',
                    style: Theme.of(context).textTheme.bodyText2)
                : Text('${veteran.deathDate.year}',
                    style: Theme.of(context).textTheme.bodyText2),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  burialPlace(BuildContext context) {
    if (veteran.burialPlace != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Место захоронения: ',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: Text('${veteran.burialPlace.city}',
                style: Theme.of(context).textTheme.bodyText2),
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        runSpacing: 10,
        children: [
          Text(
            '${veteran.surname} ${veteran.firstName} ${veteran.secondName}',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 50),
          (veteran.geocode != null)
              ? RecidenceWidget(veteran: veteran)
              : SizedBox.shrink(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Родился: ',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Expanded(
                child: (veteran.birthIsOnlyYear == null || !veteran.birthIsOnlyYear)
                    ? Text(
                        '${veteran.birthday.day}.${veteran.birthday.month}.${veteran.birthday.year} ${veteran.placeOfBirth.fullAddress()}',
                        style: Theme.of(context).textTheme.bodyText2)
                    : Text(
                        '${veteran.birthday.year} ${veteran.placeOfBirth.fullAddress()}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
              )
            ],
          ),
          deathDate(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Годы службы: ',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Expanded(
                child: (veteran.yearsInArmy.yearsInArmyStartIsOnlyYear == null ||
                        !veteran.yearsInArmy.yearsInArmyStartIsOnlyYear)
                    ? Text(
                        '${veteran.yearsInArmy.start.day}.${veteran.yearsInArmy.start.month}.${veteran.yearsInArmy.start.year} - ${veteran.yearsInArmy.end.day}.${veteran.yearsInArmy.end.month}.${veteran.yearsInArmy.end.year} ',
                        style: Theme.of(context).textTheme.bodyText2)
                    : Text(
                        '${veteran.yearsInArmy.start.year} - ${veteran.yearsInArmy.end.year} ',
                        style: Theme.of(context).textTheme.bodyText2),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Воинское звание: ',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Expanded(
                child: Text('${veteran.militaryRank}',
                    style: Theme.of(context).textTheme.bodyText2),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Награды: ',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Expanded(
                child: Text('${veteran.honors.join(', ')}',
                    style: Theme.of(context).textTheme.bodyText2),
              )
            ],
          ),
          burialPlace(context),
        ],
      ),
    );
  }
}

class RecidenceWidget extends StatelessWidget {
  const RecidenceWidget({Key key, @required this.veteran}) : super(key: key);

  final Veteran veteran;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Место жительства: ',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Text('${veteran.geocode.formattedAddress}',
                    style: Theme.of(context).textTheme.bodyText2),
              ),
              Expanded(
                flex: 3,
                child: Tooltip(
                  message: 'Показать на карте',
                  child: IconButton(
                    onPressed: () {
                      // ignore: close_sinks
                      var mapBloc =
                          MapBloc(FirestoreVeteransRepository(VeteransProvider()));
                      mapBloc.add(ShowVeteranOnMap(veteran: veteran));
                      Navigator.of(context).pushNamed('/map',
                          arguments: VeteranInfoArguments(mapBloc));
                    },
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

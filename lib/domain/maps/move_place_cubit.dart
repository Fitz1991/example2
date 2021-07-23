import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:veterans/model/veterans/veteran.dart';

part 'move_place_state.dart';

class MovePlaceCubit extends Cubit<MovePlaceState> {
  MovePlaceCubit() : super(MovePlaceInitial());

  moveToPlace(List<Veteran> veterans, {Veteran veteran, double latitude,
    double longtitude}){
    emit(MovingPlace(veterans, veteran: veteran, latitude: latitude,
        longtitude: longtitude));
  }
}

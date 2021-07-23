import 'package:veterans/model/veterans/veteran.dart';

class LazyLoadVeteran {
  List<Veteran> veterans;
  dynamic startAfter;

  LazyLoadVeteran(this.veterans, this.startAfter);
}

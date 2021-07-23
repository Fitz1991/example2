import 'package:veterans/data/firebase_providers/museums_provider.dart';
import 'package:veterans/model/museums/museum.dart';

class MuseumRepository {
  final MuseumsProvider _museumsProvider;

  MuseumRepository(this._museumsProvider);

  Stream<List<Museum>> museums() {
    return _museumsProvider.museums();
  }

  Stream<Museum> museum(String id) {
    return _museumsProvider.museum(id);
  }

  Stream<List<Museum>> searchVeteransByFullName(String text) {
    return _museumsProvider.searchMuseumsByFullName(text);
  }
}

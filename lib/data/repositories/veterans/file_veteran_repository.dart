import 'package:veterans/data/file_providers/file_veteran_provider.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';
import 'package:veterans/model/veterans/veteran.dart';

class FileVeteranRepository implements VeteranRepository {
  final FileVeteranProvider _fileVeteranProvider;

  FileVeteranRepository(this._fileVeteranProvider);

  @override
  Stream<T> veteran<T>(String path) {
//      return _fileVeteranProvider.sharePdf(path) as Stream<T>;
  }

  @override
  Stream<Output> veterans<Output, SA>({int limit, SA startAfter}) async* {
    // TODO: implement veterans
  }

  @override
  Stream<T> createVeteran<T, Data>(Data veteranData) {
    return _fileVeteranProvider.savePdf(veteranData as Veteran) as Stream<T>;
  }

  @override
  Stream<Output> veteransWithGeocode<Output>() {
    // TODO: implement veteransWithGeocode
    throw UnimplementedError();
  }
}

class VeteranRepository {
  Stream<Output> veterans<Output, SA>({int limit, SA startAfter}) async* {}

  Stream<Output> veteransWithGeocode<Output>()async* {}

  Stream<T> veteran<T>(String path) async* {}

  Stream<T> createVeteran<T, Data>(Data veteranData) async* {}


}

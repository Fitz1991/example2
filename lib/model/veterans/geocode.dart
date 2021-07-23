class Geocode{
  String formattedAddress;
  String latitude;
  String longitude;

  Geocode({this.formattedAddress, this.latitude, this.longitude});

  Geocode.fromJson(Map data){
    formattedAddress = data['formattedAddress'];
    latitude = data['latitude'].toString();
    longitude = data['longitude'].toString();
  }

  Map<String, dynamic> toJson() => {
    "formattedAddress": formattedAddress,
    "latitude": latitude,
    "longitude": longitude
  };
}
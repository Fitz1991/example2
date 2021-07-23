class Address {
  Address({
    this.region,
    this.city,
    this.street,
    this.township,
    this.village,
    this.house,
    this.index,
  });

  String region;
  String city;
  String township;
  String village;
  String street;
  String house;
  String index;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      region: (json["region"] != null) ? json["region"] : null,
      city: (json["city"] != null) ? json["city"] : null,
      township: (json["township"] != null) ? json["township"] : null,
      village: (json["village"] != null) ? json["village"] : null,
      street: (json["street"] != null) ? json["street"] : null,
      house: (json["house"] != null) ? json["house"] : null,
      index: (json["index"] != null) ? json["index"] : null);

  Map<String, dynamic> toJson() => {
        "region": region,
        "city": city,
        "township": township,
        "village": village,
        "street": street,
        "house": house,
        "index": index,
      };

  String fullAddress() {
    String fullAddress = '';
    fullAddress += (region != null && region.isNotEmpty) ? '$region, ' : "";
    fullAddress += (city != null && city.isNotEmpty) ? 'г. $city, ' : "";
    fullAddress += (township != null && township.isNotEmpty) ? 'пос. $township, ' : "";
    fullAddress += (village != null && village.isNotEmpty) ? 'дер. $village, ' : "";
    fullAddress += (street != null && street.isNotEmpty) ? ' ул. $street, ' : "";
    fullAddress += (house != null && house.isNotEmpty) ? ' д. $house  ' : "";
    int last = fullAddress.length - 2;
    if (last > 0 && fullAddress[last] == ',') {
      fullAddress = fullAddress.substring(0, last);
    }
    return fullAddress;
  }
}

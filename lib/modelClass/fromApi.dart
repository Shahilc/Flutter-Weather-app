class GetDataFrom {
  GetDataFrom({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.address,
    required this.boundingbox,
  });

  final int? placeId;
  final String? licence;
  final String? osmType;
  final int? osmId;
  final String? lat;
  final String? lon;
  final String? displayName;
  final Address? address;
  final List<String> boundingbox;

  factory GetDataFrom.fromJson(Map<String, dynamic> json){
    return GetDataFrom(
      placeId: json["place_id"],
      licence: json["licence"],
      osmType: json["osm_type"],
      osmId: json["osm_id"],
      lat: json["lat"],
      lon: json["lon"],
      displayName: json["display_name"],
      address: json["address"] == null ? null : Address.fromJson(json["address"]),
      boundingbox: json["boundingbox"] == null ? [] : List<String>.from(json["boundingbox"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "place_id": placeId,
    "licence": licence,
    "osm_type": osmType,
    "osm_id": osmId,
    "lat": lat,
    "lon": lon,
    "display_name": displayName,
    "address": address?.toJson(),
    "boundingbox": boundingbox.map((x) => x).toList(),
  };

}

class Address {
  Address({
    required this.town,
    required this.county,
    required this.stateDistrict,
    required this.state,
    required this.iso31662Lvl4,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  final String? town;
  final String? county;
  final String? stateDistrict;
  final String? state;
  final String? iso31662Lvl4;
  final String? postcode;
  final String? country;
  final String? countryCode;

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      town: json["town"],
      county: json["county"],
      stateDistrict: json["state_district"],
      state: json["state"],
      iso31662Lvl4: json["ISO3166-2-lvl4"],
      postcode: json["postcode"],
      country: json["country"],
      countryCode: json["country_code"],
    );
  }

  Map<String, dynamic> toJson() => {
    "town": town,
    "county": county,
    "state_district": stateDistrict,
    "state": state,
    "ISO3166-2-lvl4": iso31662Lvl4,
    "postcode": postcode,
    "country": country,
    "country_code": countryCode,
  };

}

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../modelClass/fromApi.dart';
import '../modelClass/weatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  String? apiKey;

  WeatherService(this.apiKey);

  Future<WeatherClass> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return WeatherClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Weather Data');
    }
  }
  Future<GetDataFrom> getAddressWithLatLong({required double latitude, required double longitude}) async{
    String getUrl="https://geocode.maps.co/reverse";
    var response = await http.get(Uri.parse('$getUrl?lat=$latitude&lon=$longitude&api_key=65b1260ceb172227677874fti861189'));

    if(response.statusCode == 200){
      return GetDataFrom.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load Weather Data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placeMarks=await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city=placeMarks[0].locality;
    return city ?? "";
  }

}

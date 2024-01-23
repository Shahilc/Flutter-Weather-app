import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

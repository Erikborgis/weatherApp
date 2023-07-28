import 'dart:convert';
import 'dart:developer' as log_dev;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

import '../viewmodels/view_model.dart';

/*
The model for the app, handles api request and data.
 */

class OpenWeatherMapModel implements WeatherModel {
  // API key and standard unit.
  static const String _apiKey = 'a526e6249a3aac513651c1afb4627fb9';
  static String _unit = "metric";

  // Weather data variables
  String? _weatherData;

  String? get weatherData => _weatherData;

  //Function to change the _unit.
  @override
  updateUnit(String newUnit) {
    _unit = newUnit;
  }

  //Fetches the weather data from the API. Prints logs if an error occurs.
  @override
  Future<void> fetchWeatherData(
      double latitude, double longitude, MyViewModel viewModel) async {
    final weatherDataList = <String>[];
    try {
      // Make API request using latitude and longitude for weather data
      String apiUrlWeather =
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=$_unit';
      http.Response weatherResponse = await http.get(Uri.parse(apiUrlWeather));

      if (weatherResponse.statusCode == 200) {
        weatherDataList.add(weatherResponse.body);
      } else {
        log_dev.log("${weatherResponse.statusCode}",
            name: "Weather API Error Code Forecasts");
        log_dev.log(weatherResponse.body, name: "Weather API Error message");
        weatherDataList.add(
            ''); // Add an empty string to the list if the API request fails
      }

      // Make API request using latitude and longitude for current weather data
      String apiUrlCurrent =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=$_unit';
      http.Response currentWeatherResponse =
          await http.get(Uri.parse(apiUrlCurrent));

      if (currentWeatherResponse.statusCode == 200) {
        weatherDataList.add(currentWeatherResponse.body);
      } else {
        log_dev.log("${currentWeatherResponse.statusCode}",
            name: "Weather API Error Code Current");
        log_dev.log(currentWeatherResponse.body,
            name: "Weather API Error message");
        weatherDataList.add(
            ''); // Add an empty string to the list if the API request fails
      }

      // Call extractWeatherData with the list of weather data
      extractWeatherData(weatherDataList, viewModel);
    } catch (e) {
      // Handle API call errors.
      if (kDebugMode) {
        print("Error fetching weather data from API: $e");
      }
    }
  }

  //Extracts the weather data from the json received from the API.
  @override
  Future<void> extractWeatherData(
      List<String> newWeatherData, MyViewModel viewModel) async {
    final weatherDataList = <Map<String, dynamic>>[];

    //Two strings in newWeatherData as two requests is placed inside of it.
    for (String weatherDataJson in newWeatherData) {
      if (weatherDataJson.isNotEmpty) {
        Map<String, dynamic> weatherData = json.decode(weatherDataJson);
        weatherDataList.add(weatherData);
      }
    }
    viewModel.updateWeatherData(weatherDataList);
  }
}

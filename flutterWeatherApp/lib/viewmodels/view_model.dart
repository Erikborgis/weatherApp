import 'dart:developer' as log_dev;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/weather_forecasts.dart';
import '../models/weather_model.dart';

/*
ViewModel for the app, handles processing of the data from the model for the view.
The ViewModel is made as a ChangeNotifier, with the views as subscribers.
The View will therefore know when they should update themselves as the ViewModel
gets new data. This by the ViewModel calling notifyListeners().
 */

class MyViewModel with ChangeNotifier {

  // A list holding the WeatherForecast objects. (Daily Forecasts)
  // The WeatherForecast will have a list inside it with the HourlyWeather
  // corresponding to that day.
  List<WeatherForecast> _dailyForecasts = [];
  List<WeatherForecast> get dailyForecasts => _dailyForecasts;

  // Holds the currentForecast object.
  CurrentForecast? currentForecast;

  final WeatherModel weatherModel;

  String currentUnit = "metric";

  // Constructor for ViewModel.
  MyViewModel(this.weatherModel);

  String? _locationMessage;
  String? get locationMessage => _locationMessage;

  // Function to change the unit used in the API request.
  void changeUnit(String newUnit) {
    weatherModel.updateUnit(newUnit);
    currentUnit = newUnit;
    notifyListeners(); // Notify listeners that the unit has changed.
  }

  // Init function that is run when the app starts.
  // Gets location permission and location.
  Future<void> init() async {
    try {
      // Check if the location permission is already granted.
      PermissionStatus permissionStatus = await Permission.location.status;
      if (permissionStatus.isGranted) {
        // If permission is granted, get the current position.
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        weatherModel.fetchWeatherData(
          position.latitude,
          position.longitude,
          this,
        );

        // Starts to listen for gps changes to update if new location is found.
        listenForLocationChanges();
      } else {
        // If permission is not granted, request the location permission.
        await requestLocationPermission();
      }
    } catch (e) {
      // Handle any errors that might occur during GPS read.
      _locationMessage = "Error fetching location data: $e";
      log_dev.log("$locationMessage", name: "Location Data");
      notifyListeners();
    }
  }

  // Function that request location permission from user.
  Future<void> requestLocationPermission() async {
    // Get the location permission.
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // If permission is granted, proceed with the weather data fetch.
      await init();
    } else {
      _locationMessage = "Please provide location permission";
      notifyListeners();
    }
  }

  // The function to update the weather data.
  // Creates the CurrentForecast object, HourlyWeather objects and WeatherForecast object.
  // The WeatherForecast is the future days, with the corresponding hourly forecasts
  // inside it. The WeatherForecast is created using the HourlyWeather with the
  // highest temp during they day.
  Future<void> updateWeatherData(List<Map<String, dynamic>> weatherData) async {
    dailyForecasts.clear();
    Map<String, dynamic> currentForecastData = weatherData[1];
    Map<String, dynamic> futureForeCast = weatherData[0];

    CurrentForecast currentForecast = CurrentForecast(
      cityName: currentForecastData['name'].toString(),
      country: currentForecastData['sys']['country'].toString(),
      temperature: currentForecastData['main']['temp'].toDouble(),
      feelsLikeTemperature:
      currentForecastData['main']['feels_like'].toDouble(),
      weatherType: currentForecastData['weather'][0]['description'].toString(),
      weatherCode: currentForecastData['weather'][0]['id'],
      weatherIcon:
      "https://openweathermap.org/img/wn/${currentForecastData['weather'][0]['icon']}.png",
    );

    final hourlyWeatherTemp = <HourlyWeather>[];
    List<dynamic> hourlyData = futureForeCast['list'];

    // Creates a dictionary holding hourly forecasts grouped by date.
    Map<String, List<HourlyWeather>> hourlyWeatherMap = {};

    // Creates the hourly forecasts and adds them to the corresponding date in
    // the dictionary.
    for (var hourly in hourlyData) {
        List<String> dateTimeParts = hourly['dt_txt'].split(" ");
        HourlyWeather hourlyWeatherObjTemp = HourlyWeather(
            date: dateTimeParts[0],
            time: dateTimeParts[1],
            temperature: hourly['main']['temp'].toDouble(),
            weatherType: hourly['weather'][0]['main'],
            weatherIcon: "https://openweathermap.org/img/wn/${hourly['weather'][0]['icon']}.png",
            wind: hourly['wind']['speed'].toDouble()
        );
        // Check if the date already exists as a key in the map
        if (hourlyWeatherMap.containsKey(dateTimeParts[0])) {
          // Adds the HourlyWeather to it if it exists.
          hourlyWeatherMap[dateTimeParts[0]]!.add(hourlyWeatherObjTemp);
        } else {
          // Creates a new list if it doesn't exist.
          hourlyWeatherMap[dateTimeParts[0]] = [hourlyWeatherObjTemp];
        }
        hourlyWeatherTemp.add(hourlyWeatherObjTemp);
      }

    // Goes through the dictionary with the dates and creates the daily forecasts.
    // It finds the hour with the highest temp and uses that data to create
    // The daily forecast. Then adds the hourly forecasts to that date object.
      for (var entry in hourlyWeatherMap.entries) {
        String date = entry.key;
        List<HourlyWeather> hourlyForecastsForDate = entry.value;

        // Find the HourlyWeather object with the highest temperature
        HourlyWeather hourlyWeatherWithMaxTemp = hourlyForecastsForDate.reduce((a, b) =>
        a.temperature > b.temperature ? a : b
        );

        // Create the WeatherForecast object using the highest temperature
        // during the day and the hourly forecasts.
        WeatherForecast weatherForecast = WeatherForecast(
          date: date,
          temperature: hourlyWeatherWithMaxTemp.temperature,
          weatherType: hourlyWeatherWithMaxTemp.weatherType,
          weatherIcon: hourlyWeatherWithMaxTemp.weatherIcon,
          wind: hourlyWeatherWithMaxTemp.wind,
          hourlyForecasts: hourlyForecastsForDate,
        );

        dailyForecasts.add(weatherForecast);

      // Update the ViewModel lists.
      _dailyForecasts = dailyForecasts;
      this.currentForecast = currentForecast;

    }
    // Notify Views that the weather data has changed.
    notifyListeners();
  }

  // Function that makes the app update when location change is made.
  Future<void> listenForLocationChanges() async {
    // Subscribe to location changes.
    Geolocator.getPositionStream().listen((Position position) {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

      // Fetch new weather data using the updated location.
      weatherModel.fetchWeatherData(
        position.latitude,
        position.longitude,
        this,
      );
    });
  }
}

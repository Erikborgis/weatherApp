import 'package:weather_app/viewmodels/view_model.dart';

/*
Abstract class for the Model.
 */

abstract class WeatherModel {
  Future<void> fetchWeatherData(
      double latitude, double longitude, MyViewModel viewModel);

  updateUnit(String newUnit);

  Future<void> extractWeatherData(
      List<String> newWeatherData, MyViewModel viewModel);
}

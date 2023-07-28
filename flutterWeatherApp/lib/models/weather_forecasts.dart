/*
The weather classes.

The weather forecasts is days of forecast, whilst the HourlyWeather is
forecast per hour. The HourlyWeather is placed in the corresponding WeatherForecast date.
By doing this we can easily keep track of what hours belong to what date.
 */

// CurrentForecast class for object.
class CurrentForecast {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLikeTemperature;
  final String weatherType;
  final int weatherCode;
  final String weatherIcon;
  final String currentUnit = "metric";

  // Constructor for CurrentForecast.
  CurrentForecast({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.weatherType,
    required this.weatherCode,
    required this.weatherIcon,
  });
}

// WeatherForecast class for object for future forecasts.
class WeatherForecast {
  final String date;
  final double temperature;
  final String weatherType;
  final String weatherIcon;
  final double wind;
  List<HourlyWeather> hourlyForecasts;

  // Constructor for WeatherForecast.
  WeatherForecast(
      {required this.date,
      required this.temperature,
      required this.weatherType,
      required this.weatherIcon,
      required this.wind,
      required this.hourlyForecasts});
}

// HourlyWeather class for object for hourly forecasts.
// These are then placed inside the right day in WeatherForecast objects.
class HourlyWeather {
  final String date;
  final String time;
  final double temperature;
  final String weatherType;
  final String weatherIcon;
  final double wind;

  // Constructor for HourlyWeather.
  HourlyWeather(
      {required this.time,
      required this.temperature,
      required this.weatherType,
      required this.weatherIcon,
      required this.wind,
      required this.date});
}

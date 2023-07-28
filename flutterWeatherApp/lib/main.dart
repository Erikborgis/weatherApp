import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/viewmodels/view_model.dart';
import 'package:weather_app/views/my_navigation_bar.dart';

import 'models/open_weather_map_model.dart';
import 'models/weather_model.dart';

/*
Weather app created by Erik Borgström for 1DV535.
The app has been created with the MVVM (Model-View-ViewModel) pattern.
 */

void main() {
  //Instantiate the model and ViewModel.
  WeatherModel weatherModel = OpenWeatherMapModel();
  MyViewModel viewModel = MyViewModel(weatherModel);

  runApp(
    MultiProvider(
      providers: [
        //Makes the ViewModel a provider so that the View can listen to changes.
        ChangeNotifierProvider<MyViewModel>.value(value: viewModel),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyViewModel>(context, listen: false);
    viewModel.init(); // Call init() here to request location permission.

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE5EBEA),
        useMaterial3: true,
      ),
      home: const MyNavigationBar(title: "Weather App"),
    );
  }
}

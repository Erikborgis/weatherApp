import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodels/view_model.dart';

/*
The Homepage View, also the default View when the app starts.
Homepage is a subscriber to the ViewModel, meaning it will update when the
ViewModel runs notifyListeners().
Shows the current forecast, it changes gifs depending on the weather code.
Shows a loading indicator if the ViewModel hasn't managed to update the weather.
 */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyViewModel>(
      builder: (context, viewModel, child) {
        // Check if the currentForecast is null
        if (viewModel.currentForecast == null) {
          // Handle the case when currentForecast is null, for example, show a loading indicator.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Get the current date.
        DateTime currentDate = DateTime.now();
        // Format the date (Day, Month day, year).
        String formattedDate = DateFormat('E, MMMM d, y').format(currentDate);

        late String backgroundImagePath;
        String unitInString;

        // Check the weatherCode and set the gif accordingly.
        if (viewModel.currentForecast!.weatherCode >= 200 &&
            viewModel.currentForecast!.weatherCode <= 232) {
          backgroundImagePath = 'assets/images/lightning-lightning-strike.gif';
        } else if (viewModel.currentForecast!.weatherCode >= 300 &&
            viewModel.currentForecast!.weatherCode <= 531) {
          backgroundImagePath = 'assets/images/rain-lights.gif';
        } else if (viewModel.currentForecast!.weatherCode >= 600 &&
            viewModel.currentForecast!.weatherCode <= 622) {
          // Default image if the weatherCode doesn't match any condition
          backgroundImagePath = 'assets/images/snow-fall.gif';
        } else if (viewModel.currentForecast!.weatherCode >= 700 &&
            viewModel.currentForecast!.weatherCode <= 781) {
          backgroundImagePath = 'assets/images/foggy-fog.gif';
        } else if (viewModel.currentForecast!.weatherCode == 800) {
          backgroundImagePath = 'assets/images/brightly_soothingly.gif';
        } else if (viewModel.currentForecast!.weatherCode >= 801 &&
            viewModel.currentForecast!.weatherCode <= 804) {
          backgroundImagePath = 'assets/images/heythatme-cloud.gif';
        } else {
          backgroundImagePath = 'assets/images/brightly_soothingly.gif';
        }

        if (viewModel.currentUnit == 'metric') {
          unitInString = '°C';
        } else if (viewModel.currentUnit == 'kelvin') {
          unitInString = 'K';
        } else {
          unitInString = '°F';
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(backgroundImagePath),
              ),
              const SizedBox(height: 20),
              Text(
                '${viewModel.currentForecast?.cityName}, ${viewModel.currentForecast?.country}',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    viewModel.currentForecast!.weatherIcon,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    viewModel.currentForecast!.weatherType,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Text(
                '${viewModel.currentForecast?.temperature.toStringAsFixed(0)}$unitInString',
                style: const TextStyle(fontSize: 35),
              ),
            ],
          ),
        );
      },
    );
  }
}

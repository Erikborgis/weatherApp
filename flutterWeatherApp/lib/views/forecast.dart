import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/view_model.dart';

/*
The Forecast View page.
Displays a list of the daily forecast, if a daily forecast is pressed
it expands and shows the hourly forecasts for that day.
Forecast is a subscriber to the ViewModel. Meaning it updates when the
ViewModel runs notifyListeners().
 */

class ForeCast extends StatelessWidget {
  const ForeCast({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyViewModel>(
      builder: (context, viewModel, child) {
        // Check if the dailyForecasts is empty
        if (viewModel.dailyForecasts.isEmpty) {
          // Handle the case when dailyForecasts is empty, for example, show a loading indicator.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        String unitInString;

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
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Expanded(
                // Wrap the ListView.builder with Expanded
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.dailyForecasts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Card(
                        elevation: 4,
                        child: ExpansionTile(
                          title: Text(viewModel.dailyForecasts[index].date),
                          subtitle: Text(
                            'Temperature: ${viewModel.dailyForecasts[index].temperature.toStringAsFixed(0)} $unitInString\nWeather type: ${viewModel.dailyForecasts[index].weatherType}\nWindspeed: ${viewModel.dailyForecasts[index].wind}',
                          ),
                          children: [
                            SingleChildScrollView(
                              // Wrap the Column with SingleChildScrollView
                              child: Column(
                                children: viewModel
                                    .dailyForecasts[index].hourlyForecasts
                                    .map((hourlyWeather) {
                                  return ListTile(
                                    title: Text(hourlyWeather.time),
                                    subtitle: Text(
                                      'Temperature: ${hourlyWeather.temperature.toStringAsFixed(0)} $unitInString\nWeather type: ${hourlyWeather.weatherType}\nWindspeed: ${hourlyWeather.wind}',
                                    ),
                                    leading: Image.network(
                                      hourlyWeather.weatherIcon,
                                      width: 40,
                                      height: 40,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

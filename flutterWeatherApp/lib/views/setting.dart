import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/viewmodels/view_model.dart';

/*
Setting page where user can change what unit the data should be showed in.
Fahrenheit, Kelvin or Celsius.
 */

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  String selectedUnit = 'metric'; // Default unit is 'metric'.

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<MyViewModel>(context, listen: false);
    selectedUnit = viewModel
        .currentUnit; // Initialize selectedUnit with the currentUnit from MyViewModel.
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Settings Content',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildUnitButton('metric'),
              buildUnitButton('imperial'),
              buildUnitButton('kelvin'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUnitButton(String unit) {
    final isSelected = unit == selectedUnit;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (!isSelected) {
            setState(() {
              selectedUnit = unit;
            });
            // Call the method to change the temperature unit in the ViewModel.
            final viewModel = Provider.of<MyViewModel>(context, listen: false);
            viewModel.changeUnit(selectedUnit);
            viewModel.init();
          }
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(isSelected ? Colors.blue : Colors.grey),
        ),
        child: Text(
          unit,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black, // Set the text color based on isSelected.
          ),
        ),
      ),
    );
  }
}

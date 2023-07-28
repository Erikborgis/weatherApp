import 'package:flutter/material.dart';
import 'package:weather_app/views/setting.dart';

import 'Forecast.dart';
import 'about.dart';
import 'home_page.dart';

/*
The navigation bar for the app.
Linked to all the different pages such as,
Homepage, Forecast, About and Settings.
 */

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyNavigationBarState createState() => MyNavigationBarState();
}

class MyNavigationBarState extends State<MyNavigationBar> {
  int _currentIndex = 0; // Index to track the selected tab.

  // Different pages needs to be added here.
  final List<Widget> _pages = [
    const HomePage(),
    const ForeCast(),
    const About(),
    const Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDBD9DB),
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        // Change the color of the selected item's label and icon.
        unselectedItemColor: Colors.grey,
        // Change the color of the unselected items' labels and icons.
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Color(0xFFDBD9DB),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Forecast',
            backgroundColor: Color(0xFFDBD9DB),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
            backgroundColor: Color(0xFFDBD9DB),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            backgroundColor: Color(0xFFDBD9DB),
          ),
        ],
      ),
    );
  }
}

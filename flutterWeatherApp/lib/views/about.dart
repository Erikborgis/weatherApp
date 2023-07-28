import 'package:flutter/material.dart';

/*
About View page.
 */

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Weather Project', style: TextStyle(fontSize: 24)),
        SizedBox(
          height: 100,
        ),
        Text(
            'This is an app developed using dart/flutter for the course 1DV535 at Linneaus University. It is using the OpenWeatherMap API to collect the weather data.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11)),
        SizedBox(height: 5),
        Text('Developed by Erik Borgström (eb223fe)',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
        SizedBox(height: 20),
        CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/images/FB_IMG_1652597913379.jpg'),
        ),
      ],
    ));
  }
}

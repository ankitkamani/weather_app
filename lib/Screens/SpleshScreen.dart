import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'Weather App'),
            ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.center,
        color: Colors.black87,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/sun.png'),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'My Weather',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  textBaseline: TextBaseline.ideographic),
            )
          ],
        ),
      ),
    );
  }
}

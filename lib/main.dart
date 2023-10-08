
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Screens/SpleshScreen.dart';
import 'package:weather_app/Controllers/ThemeProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(),)
      ],
      builder: (context, child) {

        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(color: Colors.white12),
            useMaterial3: true),
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        home: const SplashScreen(),
        // home: const MyHomePage(title: 'Weather App'),
      );
      },
    );
  }
}

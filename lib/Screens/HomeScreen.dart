
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/Apihelper.dart';
import '../Controllers/ThemeProvider.dart';
import '../modal/weatherModal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherModal? weatherModal;

  Future<WeatherModal?> data(String? cityName) async {
    weatherModal =
    (await ApiHelper.apiHelper.fetchData(cityName: cityName ?? ''))!;
    return weatherModal;
  }

  TextEditingController searchController =
  TextEditingController(text: 'rajkot');
  List day = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getdata();
  }
  void getdata()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String city = sp.getString('city')??'rajkot';
    searchController.text = city;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.name != 'none'
        ? Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const Icon(CupertinoIcons.cloud_sun,
              color: Colors.orangeAccent, size: 30),
          title: Text(widget.title),
          actions: [
            Switch(
              value: Provider.of<ThemeProvider>(context).themeMode==ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context,listen: false).changeTheme();
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 30),
            child: Container(
              margin: const EdgeInsets.all(8).copyWith(top: 0),
              child: CupertinoSearchTextField(
                controller: searchController,
                onSubmitted: (value)async{
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString('city', value.toString());
                  setState(() {});
                },
                placeholder: 'Search City',
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: data(searchController.text.trim()),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? snapshot.hasError
                  ? Container(
                  height: MediaQuery.sizeOf(context).height * .9,
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  child: const Text(
                    'Enter Valid City Name',
                    style:
                    TextStyle(fontSize: 20, color: Colors.red),
                  ))
                  : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.data?.name ?? '',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.location_on)
                        ],
                      ),
                    ),
                    Image.network(
                        'https://openweathermap.org/img/wn/${snapshot.data?.weather?[0].icon}@4x.png'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${snapshot.data?.main?.temp} °C',
                            style: const TextStyle(fontSize: 35),
                          ),
                          Text(
                            snapshot.data?.weather?[0].main
                                .toString() ??
                                '',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(day[DateTime.now().weekday - 1]),
                          Text(
                              '${snapshot.data?.main?.tempMin}°C / ${snapshot.data?.main?.tempMax}°C'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/air-flow.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.wind?.speed} km/h'),
                            const Text(
                              'WNW',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/humidity.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.main?.humidity}%'),
                            const Text(
                              'Humidity',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/pressure.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.main?.pressure} hpa'),
                            const Text(
                              'Pressure',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/temprature.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.main?.feelsLike} °C'),
                            const Text(
                              'Temperature Feels',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/work-in-progress.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.visibility} km'),
                            const Text(
                              'Visibility',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/waves.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${snapshot.data?.main?.seaLevel} km'),
                            const Text(
                              'Sea Leval',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : Container(
                  height: MediaQuery.sizeOf(context).height * .9,
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator());
            },
          ),
        ))
        : Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.center,
        child: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    );
  }
}

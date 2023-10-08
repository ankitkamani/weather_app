
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/modal/weatherModal.dart';
class ApiHelper{
  ApiHelper._();
  static final ApiHelper apiHelper = ApiHelper._();

  Future<WeatherModal?> fetchData({required String cityName})async{
    String api = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=976499cf553f403fc876d72b88bdea2a&units=metric';
    http.Response response = await http.get(Uri.parse(api));
    if(response.statusCode==200){
      WeatherModal weatherModal= weatherModalFromJson(response.body);
      // print(jsonDecode(response.body));
      return weatherModal;
    }
  }

}
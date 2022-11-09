import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'models/weather_model.dart';

class App extends StatefulWidget {
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  var mycontroller = TextEditingController();
  WeatherModel? weatherModel;
  var temperature;

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Forecast'),
        ),
        body: Center(
          child: Column(
            children: [
              textfield(),
              button(),
              const Padding(padding: EdgeInsets.all(10.0)),

              Text('${temperature ?? 'Invalid City Name'}'),
              Text('${weatherModel?.main?.pressure ?? 'Invalid City Name'}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget textfield(){
    return Padding(padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: mycontroller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter City Name',
        ),
      ),
    );
  }

  Widget button(){
    return ElevatedButton(
        onPressed: () async {
          //print(mycontroller.text);
          weatherModel = await getWeather(mycontroller.text);
          temperature = weatherModel?.main?.temp;
          //temperature = (temperature - 273.15).toStringAsFixed(2).toString()+"°C";
         // print("$temperature"+ "dfdkdjfdlkjfdlkfjdjfdfdkfj");
          if(temperature == null) {
            temperature = 'Enter a valid city name';
          } else {
            temperature = (temperature - 273.15).toStringAsFixed(2).toString()+"°C";
            //temperature = 'Temperature = ' + temperature + ' degree celcius';
            print("$temperature"+"dfjdkfldjfkldjfkldjf");
          }
          setState(() {});
        },
        child: Text('Get Weather info')
    );
  }

  getWeather(String city) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=8f87eb169586792978bebf24aa790cb9';

    try {
      final res = await get(Uri.parse(url));
      print(res.body);
      if(res.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(res.body));
      }
    } catch(e) {
      //print(e);
      return null;
    }
  }
}

import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWeatherSensorPlugin {
  static const MethodChannel _methodChannel = MethodChannel('flutter_weather_sensor_plugin');
  static const EventChannel _eventChannel = EventChannel('flutter_weather_sensor_plugin/readings');

  static Future<void> startSensorReadings() async {
    await _methodChannel.invokeMethod('startSensorReadings');
  }

  static Future<void> stopSensorReadings() async {
    await _methodChannel.invokeMethod('stopSensorReadings');
  }

  static Future<void> set(int readingInterval) async {
    await _methodChannel.invokeMethod('set', {'readingInterval': readingInterval});
  }

  static Future<Stream<dynamic>> collectReadings() async {
    await _methodChannel.invokeMethod('collectReadings');
    return _eventChannel.receiveBroadcastStream();
  }
}

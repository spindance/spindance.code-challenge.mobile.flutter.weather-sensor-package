import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_sensor_plugin/flutter_weather_sensor_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_weather_sensor_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startSensorReadings', () async {
    var result = 'failure';
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'startSensorReadings') {
        result = 'success';
      }
    });

    await FlutterWeatherSensorPlugin.startSensorReadings();
    expect(result, 'success');
  });

  test('startSensorReadings', () async {
    var result = 'failure';
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'startSensorReadings') {
        result = 'success';
      }
    });

    await FlutterWeatherSensorPlugin.startSensorReadings();
    expect(result, 'success');
  });

  test('stopSensorReadings', () async {
    var result = 'failure';
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'stopSensorReadings') {
        result = 'success';
      }
    });

    await FlutterWeatherSensorPlugin.stopSensorReadings();
    expect(result, 'success');
  });

  test('set readingInterval', () async {
    var interval = 0;
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'set') {
        interval = methodCall.arguments['readingInterval'];
      }
    });

    await FlutterWeatherSensorPlugin.set(12);
    expect(interval, 12);
  });

  test('collectReadings', () async {
    var result = 'failure';
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'collectReadings') {
        result = 'success';
      }
    });

    var stream = await FlutterWeatherSensorPlugin.collectReadings();
    expect(result, 'success');
    expect(stream.isBroadcast, true);
  });
}

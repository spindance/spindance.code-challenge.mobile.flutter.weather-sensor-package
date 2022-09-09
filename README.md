# flutter_weather_sensor_plugin

Flutter wrapper of native weather sensor generation libraries.

## Using this package

In order to use this package in your project, you will need to clone it recursively to include it's submodules.
```
git clone --recurse-submodules https://github.com/spindance/spindance.code-challenge.mobile.flutter.weather-sensor-package
```

Add a dependency in your `pubspec.yaml` pointing to your newly cloned package.
```
dependencies:
  ...
  flutter_weather_sensor_plugin:
    path: /path/to/spindance.code-challenge.mobile.flutter.weather-sensor-package
```

Run `flutter pub get` and add the following import to your dart file:
```
import 'package:flutter_weather_sensor_plugin/flutter_weather_sensor_plugin.dart';
```

You can then access specific functions by calling `FlutterWeatherSensorPlugin.<functionName>`.
#import "FlutterWeatherSensorPlugin.h"
#if __has_include(<flutter_weather_sensor_plugin/flutter_weather_sensor_plugin-Swift.h>)
#import <flutter_weather_sensor_plugin/flutter_weather_sensor_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_weather_sensor_plugin-Swift.h"
#endif

@implementation FlutterWeatherSensorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWeatherSensorPlugin registerWithRegistrar:registrar];
}
@end

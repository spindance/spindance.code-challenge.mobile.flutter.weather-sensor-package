import Flutter
import UIKit
import Combine

@available(iOS 13.0, *)
public class SwiftFlutterWeatherSensorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var sinkSubscription: AnyCancellable?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "flutter_weather_sensor_plugin", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "flutter_weather_sensor_plugin/readings", binaryMessenger: registrar.messenger())
      
    let instance = SwiftFlutterWeatherSensorPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "startSensorReadings":
        startSensorReadings()
        result("success")
      case "stopSensorReadings":
        stopSensorReadings()
        result("success")
      case "set":
        if let args = call.arguments as? Dictionary<String, Any>,
          let interval = args["readingInterval"] as? UInt {
            setInterval(interval)
          } else {
            result(FlutterError.init(code:"invalidArgs", message: "Reading interval must be a positive integer.", details: "Expected 1 UInt arg."))
          }
        result("success")
      case "collectReadings":
        collectReadings()
        result("success")
      default:
        result(FlutterMethodNotImplemented)
    }
  }
    
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }
    
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
    
  private func collectReadings() {
    sinkSubscription = WeatherSensorService.shared.reader.sensorReadingsPublisher.sink{ [weak self] value in
      self?.eventSink?("\(value)")
    }
  }
    
  private func setInterval(_ readingInterval: UInt) {
    WeatherSensorService.shared.reader.set(readingInterval: readingInterval)
  }
    
  private func startSensorReadings() {
    WeatherSensorService.shared.reader.startSensorReadings()
  }
    
  private func stopSensorReadings() {
    sinkSubscription?.cancel()
    WeatherSensorService.shared.reader.startSensorReadings()
  }
}

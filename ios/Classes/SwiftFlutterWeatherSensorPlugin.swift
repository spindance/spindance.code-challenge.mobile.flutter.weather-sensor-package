import Flutter
import UIKit
import Combine

@available(iOS 13.0, *)
public class SwiftFlutterWeatherSensorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink? = nil
  private var sinkSubscription: AnyCancellable?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "flutter_weather_sensor_plugin", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "flutter_weather_sensor_plugin/readings", binaryMessenger: registrar.messenger())
      
    let instance = SwiftFlutterWeatherSensorPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "startSensorReadings") {
      startSensorReadings()
      result("success")
    } else if (call.method == "stopSensorReadings") {
      stopSensorReadings()
      result("success")
    } else if (call.method == "set") {
      if let args = call.arguments as? Dictionary<String, Any>,
        let interval = args["readingInterval"] as? NSInteger {
          setInterval(interval)
        } else {
          result(FlutterError.init(code:"invalidArgs", message: "Reading interval must be an integer.", details: "Expected 1 Int arg."))
        }
      result("success")
    } else if (call.method == "collectReadings") {
      collectReadings()
      result("success")
    } else {
      result(FlutterMethodNotImplemented)
      return
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
    sinkSubscription = WeatherSensorService.shared.reader.sensorReadingsPublisher.sink{ value in
      if (self.eventSink != nil) {
        self.eventSink!("\(value)")
      }
    }
  }
    
  private func setInterval(_ readingInterval: NSInteger) {
    WeatherSensorService.shared.reader.set(readingInterval: UInt(readingInterval))
  }
    
  private func startSensorReadings() {
    WeatherSensorService.shared.reader.startSensorReadings()
  }
    
  private func stopSensorReadings() {
    if (self.sinkSubscription != nil) {
      self.sinkSubscription?.cancel()
    }
    WeatherSensorService.shared.reader.startSensorReadings()
  }

}

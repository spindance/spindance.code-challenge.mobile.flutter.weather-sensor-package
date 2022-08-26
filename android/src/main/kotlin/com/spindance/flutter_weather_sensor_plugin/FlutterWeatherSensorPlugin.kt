package com.spindance.flutter_weather_sensor_plugin

import androidx.annotation.NonNull
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import WeatherSensorService
import android.hardware.SensorEventListener
import java.util.logging.StreamHandler

/** FlutterWeatherSensorPlugin */
class FlutterWeatherSensorPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventStream : EventChannel
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_weather_sensor_plugin")
    channel.setMethodCallHandler(this)

    eventStream = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_weather_sensor_plugin/readings")
    eventStream.setStreamHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "startSensorReadings") {
      startSensorReadings()
      result.success("success")
    } else if (call.method == "stopSensorReadings") {
      stopSensorReadings()
      result.success("success")
    } else if (call.method == "set") {
      setInterval(call.argument("readingInterval") ?: 1)
      result.success("success")
    } else if (call.method == "collectReadings") {
      collectReadings()
      result.success("success")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  val collectScope = CoroutineScope(Dispatchers.Main)
  fun collectReadings() {
      collectScope.launch {
        WeatherSensorService.reader.sensorReaderFlow.collect{value -> eventSink?.success(value.toString())}
    }
  }

  fun setInterval(readingInterval: Int) {
    WeatherSensorService.reader.set(readingInterval.toUInt())
  }

  fun startSensorReadings() {
    WeatherSensorService.reader.startSensorReadings()
  }

  fun stopSensorReadings() {
    collectScope.cancel()
    WeatherSensorService.reader.stopSensorReadings()
  }
}

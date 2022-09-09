package com.spindance.flutter_weather_sensor_plugin

import WeatherSensorService
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

/** FlutterWeatherSensorPlugin */
class FlutterWeatherSensorPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var collectScope: CoroutineScope? = null
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(
      @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  ) {
    methodChannel =
        MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_weather_sensor_plugin")
    methodChannel.setMethodCallHandler(this)

    eventChannel =
        EventChannel(flutterPluginBinding.binaryMessenger, "flutter_weather_sensor_plugin/readings")
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "startSensorReadings" -> {
        startSensorReadings()
        result.success("success")
      }
      "stopSensorReadings" -> {
        stopSensorReadings()
        result.success("success")
      }
      "set" -> {
        setInterval(call.argument("readingInterval") ?: 1)
        result.success("success")
      }
      "collectReadings" -> {
        collectReadings()
        result.success("success")
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  fun collectReadings() {
    collectScope = CoroutineScope(Dispatchers.Main)
    collectScope?.launch {
      WeatherSensorService.reader.sensorReaderFlow.collect { value ->
        eventSink?.success(value.toString())
      }
    }
  }

  fun setInterval(readingInterval: Int) {
    WeatherSensorService.reader.set(readingInterval.toUInt())
  }

  fun startSensorReadings() {
    WeatherSensorService.reader.startSensorReadings()
  }

  fun stopSensorReadings() {
    collectScope?.cancel()
    WeatherSensorService.reader.stopSensorReadings()
  }
}

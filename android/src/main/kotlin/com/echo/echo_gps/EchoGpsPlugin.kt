package com.echo.echo_gps

import android.content.Context
import android.content.Context.LOCATION_SERVICE
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.getSystemService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

/** EchoGpsPlugin */
class EchoGpsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var locationManager: LocationManager
  private lateinit var locationListener: LocationListener

  private lateinit var context: Context


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "echo_gps")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "getCurrentLocation" -> getCurrentLocation(result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getCurrentLocation(result: Result) {
    locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager

    locationListener = object : LocationListener {
      override fun onLocationChanged(location: Location) {
        val latitude = location.latitude
        val longitude = location.longitude
        result.success("$latitude,$longitude")

        locationManager.removeUpdates(this)
      }

      override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
      override fun onProviderEnabled(provider: String) {}
//      override fun onProviderDisabled(provider: String) {}

      override fun onProviderDisabled(provider: String) {
        // 在获取位置失败时，同样取消位置监听器
        locationManager.removeUpdates(this)
      }
    }

    try {
      if (ActivityCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
        Log.i("echo_info", "权限错误")
        // 权限检查
        result.error("权限错误", "Location permission denied", null)
        return
      }
      locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0L, 0f, locationListener)
    } catch (e: Exception) {
      Log.i("echo_info", "Failed to get location")
      result.error("ERROR", "Failed to get location", e.localizedMessage)
    }
  }



}

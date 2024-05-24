import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'echo_gps_platform_interface.dart';

/// An implementation of [EchoGpsPlatform] that uses method channels.
class MethodChannelEchoGps extends EchoGpsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('echo_gps');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getCurrentLocation() async{
    final version = await methodChannel.invokeMethod<String>('getCurrentLocation');
    return version;
  }
}

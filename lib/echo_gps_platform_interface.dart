import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'echo_gps_method_channel.dart';

abstract class EchoGpsPlatform extends PlatformInterface {
  /// Constructs a EchoGpsPlatform.
  EchoGpsPlatform() : super(token: _token);

  static final Object _token = Object();

  static EchoGpsPlatform _instance = MethodChannelEchoGps();

  /// The default instance of [EchoGpsPlatform] to use.
  ///
  /// Defaults to [MethodChannelEchoGps].
  static EchoGpsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EchoGpsPlatform] when
  /// they register themselves.
  static set instance(EchoGpsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> getCurrentLocation(){
    throw UnimplementedError('getCurrentLocation() has not been implemented.');
  }
}

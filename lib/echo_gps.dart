
import 'echo_gps_platform_interface.dart';

class EchoGps {
  Future<String?> getPlatformVersion() {
    return EchoGpsPlatform.instance.getPlatformVersion();
  }

  Future<String?> getCurrentLocation(){
    return EchoGpsPlatform.instance.getCurrentLocation();
  }
}

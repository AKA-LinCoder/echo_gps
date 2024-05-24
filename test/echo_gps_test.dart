// import 'package:flutter_test/flutter_test.dart';
// import 'package:echo_gps/echo_gps.dart';
// import 'package:echo_gps/echo_gps_platform_interface.dart';
// import 'package:echo_gps/echo_gps_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockEchoGpsPlatform
//     with MockPlatformInterfaceMixin
//     implements EchoGpsPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final EchoGpsPlatform initialPlatform = EchoGpsPlatform.instance;
//
//   test('$MethodChannelEchoGps is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelEchoGps>());
//   });
//
//   test('getPlatformVersion', () async {
//     EchoGps echoGpsPlugin = EchoGps();
//     MockEchoGpsPlatform fakePlatform = MockEchoGpsPlatform();
//     EchoGpsPlatform.instance = fakePlatform;
//
//     expect(await echoGpsPlugin.getPlatformVersion(), '42');
//   });
// }

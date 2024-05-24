import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:echo_gps/echo_gps.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _echoGpsPlugin = EchoGps();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _echoGpsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '视频录制',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const RecordVideo(),
      builder: EasyLoading.init(),
      home: const LocationView(),
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('$_platformVersion\n'),
              ElevatedButton(onPressed: ()async{
                String platformVersion;
                try {

                  if(await Permission.location.request().isGranted){
                    print("点我干嘛");
                    platformVersion =
                        await _echoGpsPlugin.getCurrentLocation() ?? 'Unknown platform version';
                    print("这是调取结果$platformVersion");
                    _platformVersion = platformVersion;
                    setState(() {

                    });
                  }else{

                    print("没有权限");
                  }



                } on PlatformException {
                  platformVersion = 'Failed to get platform version.';
                }
              }, child: const Text("获取当前经纬度"))
            ],
          ),
        ),
      ),
    );
  }
}

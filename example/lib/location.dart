import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:echo_gps/echo_gps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



/// FileName location
///
/// @Author LinGuanYu
/// @Date 2024/5/21 08:50
///
/// @Description TODO

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final EchoGps _geolocatorPlatform = EchoGps();
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  bool positionStreamStarted = false;

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    initData();
    _controller = ScrollController();
  }

  initData() async {
    var data = await getStringData("positionItems");
    if (data != null) {
      jsonDecode(data).forEach((item) {
        _positionItems.add(_PositionItem.fromJson(item));
      });
    }
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "定位",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [TextButton(onPressed: ()async{
          await deleteStringData("positionItems");
          _positionItems.clear();
          setState(() {

          });

        }, child: const Text("一键清空",style: TextStyle(color: Colors.white),))],
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: _positionItems.length,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];
          if (positionItem.type == _PositionItemType.log) {
            return Container();
          } else {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              color: Colors.deepPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "当前时间:${positionItem.currentTime}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    positionItem.displayValue,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "此次定位耗时：${positionItem.differenceInSeconds} 秒",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          sizedBox,
          FloatingActionButton(
            onPressed: _getCurrentPosition,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
          sizedBox,
        ],
      ),
    );
  }

  Future<void> saveStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> deleteStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }


  ///@title _getCurrentPosition
  ///@description 获取当前定位
  ///@return: Future<void>
  ///@updateTime 2024/5/21 09:11
  ///@author LinGuanYu
  Future<void> _getCurrentPosition() async {

    if(!await Permission.location.request().isGranted){
      return;
    }

    var current = DateTime.now();
    EasyLoading.show(status:  "定位中...");
    final position = await _geolocatorPlatform.getCurrentLocation();
     String? longitude;
     String? latitude;

    if(position!=null){
      var res = position.split(",");
      latitude = res[0];
      longitude = res[1];

    }
    if(longitude==null || latitude==null){
      EasyLoading.dismiss();
      EasyLoading.showError("获取定位失败");
      return;
    }
    EasyLoading.dismiss();
    var current2 = DateTime.now();
    var differenceInSeconds =
        current2.difference(current).inMicroseconds / 1000000.0;
    _updatePositionList(
      _PositionItemType.position,
      "经度:$longitude   纬度:$latitude",
      differenceInSeconds: differenceInSeconds,
      currentTime: current2.toIso8601String(),
    );
  }

  void _updatePositionList(_PositionItemType type, String displayValue,
      {double? differenceInSeconds, String? currentTime}) {
    _positionItems.add(
        _PositionItem(type, displayValue, differenceInSeconds, currentTime));
    //记录缓存
    saveStringData("positionItems", jsonEncode(_positionItems));
    setState(() {});
    //滚到listview最下面
    _controller.animateTo(
      _controller.position.maxScrollExtent+100,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(
      this.type, this.displayValue, this.differenceInSeconds, this.currentTime);

  final _PositionItemType type;
  final String displayValue;
  double? differenceInSeconds;
  String? currentTime;

  Map<String, dynamic> toJson() {
    return {
      'type': _positionItemTypeToString(type),
      'displayValue': displayValue,
      'differenceInSeconds': differenceInSeconds,
      'currentTime': currentTime,
    };
  }

  // 从 JSON (Map<String, dynamic>) 创建 _PositionItem
  factory _PositionItem.fromJson(Map<String, dynamic> json) {
    return _PositionItem(
      _PositionItemType.values.firstWhere(
              (e) => e.toString() == '_PositionItemType.${json['type']}'),
      json['displayValue'],
      json['differenceInSeconds'],
      json['currentTime'],
    );
  }

  // 辅助方法：将字符串转换回 _PositionItemType 枚举
  _PositionItemType _stringToPositionItemType(String typeString) {
    return _PositionItemType.values.firstWhere(
            (type) => type.toString().split('.').last == typeString);
  }


  // 辅助方法：将 _PositionItemType 枚举转换为字符串
  String _positionItemTypeToString(_PositionItemType type) {
    return type.toString().split('.').last;
  }
}

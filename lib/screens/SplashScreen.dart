import 'package:flutter/material.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';

import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/screens/HomePageScreen.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    globals.deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder<String>(
            future: getSavedUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Image(
                  image: AssetImage('images/splashscreen.png'),
                );
              } else {
                if (snapshot.data == 'OK') {
                  return FutureBuilder<bool>(
                      future: userSessionValidate(),
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot2) {
                        if (snapshot2.connectionState == ConnectionState.waiting) {
                          return ProgressBar();
                        } else {
                          if (snapshot2.hasError)
                            return Center(child: Text('Error: ${snapshot2.error}'));
                          else {
                            if (snapshot2.data) {
                              return Home();
                            } else {
                              return LoginScreen();
                            }
                          }
                        }
                      });
                } else {
                  return LoginScreen();
                }
              }
            })
    );
  }
}

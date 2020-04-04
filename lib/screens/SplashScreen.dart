import 'package:flutter/material.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/screens/HomePageScreen.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

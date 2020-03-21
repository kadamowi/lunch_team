import 'package:flutter/material.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/screens/HomePageScreen.dart';
import 'package:lunch_team/model/LoginRequest.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/model/globals.dart' as globals;


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Lunch Team'),
      //),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder<LoginUser>(
              future: getSavedUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Image(
                    image: AssetImage('images/splashscreen.png'),
                  );
                } else {
                  if (snapshot.data.username != null &&
                      snapshot.data.password != null) {
                    return FutureBuilder<String>(
                        future: loginApp(
                            snapshot.data.username, snapshot.data.password),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot2) {
                          if (snapshot2.connectionState != ConnectionState.done) {
                            return Text(''); //Image(image: AssetImage('images/splashscreen.png'),);
                          } else {
                            if (snapshot2.data == null) {
                              return Home();
                            } else {
                              globals.sessionLunch = SessionLunch(
                                  snapshot.data.username,
                                  snapshot.data.password,
                                  null
                              );
                              return LoginScreen();
                            }
                          }
                        });
                  } else {
                    return LoginScreen();
                  }
                }
              })
          ),
    );
  }
}

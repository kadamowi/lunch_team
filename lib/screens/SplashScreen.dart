import 'package:flutter/material.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/screens/HomeScreen.dart';
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
                            return Image(
                              image: AssetImage('images/splashscreen.png'),
                            );
                          } else {
                            if (snapshot2.data != null) {
                              globals.sessionLunch = SessionLunch(
                                  snapshot.data.username,
                                  snapshot2.data
                              );
                              return HomeScreen();
                            } else
                              return LoginScreen();
                          }
                          /*
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 60),
                              Text(
                                snapshot.data.username,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data.password,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot2.data,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                          */
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

import 'package:flutter/material.dart';
import 'package:lunch_team/data/LoginApi.dart';

import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/screens/UserPasswordScreen.dart';
import 'package:lunch_team/screens/UserProfileScreen.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';


class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-50,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  color: Colors.orange[800],
                  textColor: Colors.white,
                  child: Text("User details"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  color: Colors.orange[800],
                  textColor: Colors.white,
                  child: Text("User password"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPasswordScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Logout"),
                  onPressed: () {
                    logoutApp().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(),
                        ),
                      );
                    });
                  },
                ),
              ),
              Spacer(),
              MessageError(message: message),
              VersionText(),
            ],
          ),
        ),
      ),
    );
  }
}


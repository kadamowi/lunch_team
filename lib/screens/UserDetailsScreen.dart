import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/screens/UserPasswordScreen.dart';
import 'package:lunch_team/screens/UserProfileScreen.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/globals.dart' as globals;

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
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(20.0),
                    height: 80,
                    child: (globals.userLogged.avatarUrl.length > 0)
                        ? CachedNetworkImage(placeholder: (context, url) => CircularProgressIndicator(), imageUrl: globals.userLogged.avatarUrl)
                        : Image(
                            image: AssetImage('images/avatar.png'),
                          ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            globals.userLogged.displayName,
                            style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            globals.userLogged.username,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            globals.userLogged.email,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 100,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('User details',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text('Edit',
                            style: TextStyle(
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 100,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Password',
                          style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text('Change',
                            style: TextStyle(
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPasswordScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Logout"),
                  onPressed: () {
                    logoutApp().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
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

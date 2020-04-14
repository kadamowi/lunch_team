import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/request/LoginRequest.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/screens/HomePageScreen.dart';
import 'package:lunch_team/screens/UserScreen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  LoginUser loginUser = new LoginUser(username: '', password: '');
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          //height: 600,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                height: 180,
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              SizedBox(height: 20.0,width: double.infinity),
              Form(
                  key: _formStateKey,
                  autovalidate: true,
                  child: Column(children: <Widget>[
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),),
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                prefixIcon: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "enter your name",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              initialValue: globals.sessionUser,
                              onSaved: (value) => loginUser.username = value.trim(),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                prefixIcon: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "enter your password",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              //initialValue: globals.password,
                              onSaved: (value) => loginUser.password = value.trim(),
                              obscureText: true,
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.orange[800],
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Login"),
                        onPressed: () {
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                            loginApp(loginUser.username,loginUser.password).then((value)  {
                              if (value == null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  message = value;
                                });
                              }
                            });
                          };
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                  ])),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.grey[800],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Sign up"),
                      onPressed: () {
                        if (_formStateKey.currentState.validate()) {
                          _formStateKey.currentState.save();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.grey[800],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Lost password"),
                      onPressed: () {
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              MessageError(message: message),
              Text('Version '+_packageInfo.version,),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/LoginRequest.dart';
import 'package:lunch_team/screens/HomeScreen.dart';
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
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                height: 200,
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
                                      color: Colors.lightGreen,
                                    )),
                                hintText: "enter your name",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              initialValue: globals.sessionLunch.username,
                              onSaved: (value) => loginUser.username = value,
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
                              initialValue: globals.sessionLunch.password,
                              onSaved: (value) => loginUser.password = value,
                              obscureText: true,
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 25.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.orange[800],
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Login".toUpperCase()),
                        onPressed: () {
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                          }
                          _loginButton(context);
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Sign up".toUpperCase()),
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
                            color: Colors.black,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Forgot password".toUpperCase()),
                            onPressed: () {
                            },
                          ),
                        ),
                      ],
                    ),
                  ])),
              Spacer(),
              Text(
                message,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  'Version '+_packageInfo.version,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginButton(BuildContext context) async {
    // prepare JSON for request
    String reqJson =
        json.encode(LoginRequest(request: 'user.login', arguments: loginUser));
    // make POST request
    Response response = await post(urlApi, headers: headers, body: reqJson);
    var result = jsonDecode(response.body);
    var res = result['response'];
    if (res != null) {
      print(loginUser.username + ' entered');
      String sessionId = res['session'];
      if (sessionId != null && sessionId != 'null') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', loginUser.username);
        prefs.setString('password', loginUser.password);
        final SessionLunch sessionLunch =
            new SessionLunch(loginUser.username, loginUser.password, sessionId);
        globals.sessionLunch = sessionLunch;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(),
              settings: RouteSettings(
                arguments: sessionLunch,
              )),
        );
      } else {
        setState(() {
          message = 'Incorrect login ' + res.toString();
        });
      }
    } else {
      setState(() {
        message = 'Incorrect login';
      });
    }
  }

  Future<LoginUser> getSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return new LoginUser(
        username: (prefs.getString('username') ?? ''),
        password: (prefs.getString('password') ?? ''));
  }
}

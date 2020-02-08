import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/LoginRequest.dart';
import 'package:lunch_team/screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  LoginUser loginUser = new LoginUser(username: '', password: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient:
              LinearGradient(colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorDark,
              ])),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                height: 100,
                child: Image(
                  image: AssetImage('images/LunchTeam.png'),
                ),
              ),
              Text(
                "Lunch Team",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              FutureBuilder<String> (
                future: getSavedUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null)
                  return Text('loading');
                  else
                    return Form(
                        key: _formStateKey,
                        autovalidate: true,
                        child: Column(children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                  padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                          bottomRight: Radius.circular(10.0))),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.lightGreen,
                                  )),
                              hintText: "enter your name",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            initialValue: snapshot.data,
                            onSaved: (value) => loginUser.username = value,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              prefixIcon: Container(
                                  padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                          bottomRight: Radius.circular(10.0))),
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.lightGreen,
                                  )),
                              hintText: "enter your password",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            onSaved: (value) => loginUser.password = value,
                            obscureText: true,
                          ),
                          SizedBox(height: 30.0),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.white,
                              textColor: Colors.lightGreen,
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Login".toUpperCase()),
                              onPressed: () {
                                _loginButton(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                          Text(
                            message,
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                          //Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                textColor: Colors.white70,
                                child: Text("Create Account".toUpperCase()),
                                onPressed: () {
                                  _createAccount();
                                },
                              ),
                              Container(
                                color: Colors.white54,
                                width: 2.0,
                                height: 20.0,
                              ),
                              FlatButton(
                                textColor: Colors.white70,
                                child: Text("Forgot Password".toUpperCase()),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                        ]));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _createAccount() async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
    // prepare JSON for request
    String reqJson = json
        .encode(LoginRequest(request: 'user.register', arguments: loginUser));
    // make POST request
    Response response = await post(urlApi, headers: headers, body: reqJson);
    print('response:' + response.toString());
    var result = jsonDecode(response.body);
    var resp = result['response'];
    if (resp != null) {
      bool registerUser = resp['registerUser'];
      if (registerUser) {
        setState(() {
          message = 'User "' + loginUser.username + '" registered';
        });
      } else {
        setState(() {
          message = 'User "' + loginUser.username + '" not registered';
        });
      }
    } else {
      message = 'Register error ' + result.toString();
    }
  }

  void _loginButton(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
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
        print('loginUser loginUser = '+loginUser.username);

        //print('Session id:' + sessionId.substring(1, 10));
        final SessionLunch sessionLunch =
            new SessionLunch(loginUser.username, sessionId);
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

  Future <String> getSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      return (prefs.getString('username') ?? '');
  }
}

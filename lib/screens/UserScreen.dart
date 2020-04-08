import 'package:flutter/material.dart';
import 'package:lunch_team/model/User.dart';
import 'package:lunch_team/request/LoginRequest.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  LoginUser loginUser = new LoginUser(username: '', password: '');
  String secondPassword;
  String message = "";
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Registration'),
      //),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                height: 180,
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              SizedBox(height: 20.0, width: double.infinity),
              Form(
                  key: _formStateKey,
                  autovalidate: false,
                  child: Column(children: <Widget>[
                    Container(
                      height: 240,
                        color: Colors.white,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Register new user',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                prefixIcon: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "enter your name",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (value.length == 0)
                                  return "username is empty";
                                return null;
                              },
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
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
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
                              validator: (value) {
                                if (value.length == 0)
                                  return "passwords is empty";
                                return null;
                              },
                              onSaved: (value) => loginUser.password = value,
                              obscureText: true,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16.0),
                                prefixIcon: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "retype your password",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (value.length == 0)
                                  return "passwords is empty";
                                return null;
                              },
                              onSaved: (value) => secondPassword = value,
                              obscureText: true,
                            ),
                          ],
                        )),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.orange[800],
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Sign up"),
                        onPressed: () {
                          print(loginUser.username);
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                            if (loginUser.password == secondPassword) {
                              registerUser(loginUser).then((value) {
                                if (value != null)
                                  setState(() {
                                    message = value;
                                  });
                                else
                                  Navigator.pop(context);
                              });
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(),
                      ),
                    ),
                  ])),
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

import 'package:flutter/material.dart';
import 'package:lunch_team/data/LoginApi.dart';
import 'package:lunch_team/data/UserApi.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<FormState> _formStateKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKey2 = GlobalKey<FormState>();
  String message = '';
  String oldPass;
  String newPass;
  String newPass2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height-50,
          child: Column(
            children: <Widget>[
              Form(
                  key: _formStateKey1,
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
                                'User details',
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
                                hintText: "display name",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              initialValue: globals.userLogged.displayName,
                              validator: (value) {
                                if (value.length == 0)
                                  return "display name is empty";
                                return null;
                              },
                              onSaved: (value) =>
                                  globals.userLogged.displayName = value,
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
                                      Icons.picture_in_picture,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "avatar",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              initialValue: globals.userLogged.avatarUrl,
                              onSaved: (value) =>
                                  globals.userLogged.avatarUrl = value,
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
                                      Icons.email,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "email",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              initialValue: globals.userLogged.email,
                              onSaved: (value) =>
                                  globals.userLogged.email = value,
                            ),
                            SizedBox(height: 10.0),
                          ],
                        )),
                    //SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.orange[800],
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Save"),
                            onPressed: () {
                              if (_formStateKey1.currentState.validate()) {
                                _formStateKey1.currentState.save();
                                editUser().then((value) {
                                  if (value == null) {
                                    message = 'Data changed';
                                    setState(() {});
                                  }
                                  else {
                                    message = value;
                                    setState(() {});
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        /*
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.orange[800],
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Delete".toUpperCase()),
                            onPressed: () {},
                          ),
                        ),
                        */
                      ],
                    ),
                  ])),
              Form(
                  key: _formStateKey2,
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
                                'Change password',
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
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "old password",
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
                              onSaved: (value) => oldPass = value,
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
                                hintText: "new password",
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
                              onSaved: (value) => newPass = value,
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
                              onSaved: (value) => newPass2 = value,
                              obscureText: true,
                            ),
                          ],
                        )),
                    //SizedBox(height: 10.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        color: Colors.orange[800],
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Change password"),
                        onPressed: () {
                          if (_formStateKey2.currentState.validate()) {
                            _formStateKey2.currentState.save();
                            if (newPass == newPass2) {
                              passwordUser(oldPass,newPass).then((value) {
                                if (value != null)
                                  setState(() {
                                    message = value;
                                  });
                              });
                            } else {
                              setState(() {
                                message = 'passwords not match';
                              });
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(),
                      ),
                    ),

                  ])),
              Spacer(),
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
              MessageError(message: message),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lunch_team/data/UserApi.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';

class UserPasswordScreen extends StatefulWidget {
  @override
  _UserPasswordScreenState createState() => _UserPasswordScreenState();
}

class _UserPasswordScreenState extends State<UserPasswordScreen> {
  final GlobalKey<FormState> _formStateKey2 = GlobalKey<FormState>();
  String message = '';
  String oldPass;
  String newPass;
  String newPass2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
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
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "old password",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (value.length == 0) return "passwords is empty";
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
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "new password",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (value.length == 0) return "passwords is empty";
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
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.orange[800],
                                    )),
                                hintText: "retype your password",
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (value.length == 0) return "passwords is empty";
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
                              passwordUser(oldPass, newPass).then((value) {
                                if (value == null) {
                                  Navigator.pop(context);
                                } else {
                                  message = value;
                                  setState(() {});
                                }
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
              MessageError(message: message),
              VersionText(),
            ],
          ),
        ),
      ),
    );
  }
}

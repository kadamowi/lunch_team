import 'package:flutter/material.dart';

import 'package:lunch_team/model/User.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.grey[200],
          child: Column(

            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                height: 100,
                child: Image(
                  image: AssetImage('images/LunchTeam.png'),
                ),
              ),
              Form(
                key: _formStateKey,
                autovalidate: true,

                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        prefixIcon: Container(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0),
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Icon(
                              Icons.person,
                              color: Colors.orange[800],
                            )),
                        hintText: "login",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      onSaved: (value) => user.username = value,
                    ),
                    SizedBox(height: 10.0),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/LunchRequest.dart';

class LunchScreen extends StatefulWidget {
  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  Lunch lunch = new Lunch(
    lunchId: 0,
    restaurantId: globals.restaurantSelected.restaurantId,
    username: globals.sessionLunch.username,
    lunchType: 0,
    lunchDescription: '',
    transportCost: 0,
    lunchOrderTime: DateTime.now().add(Duration(hours: 1)),
    lunchLunchTime: DateTime.now().add(Duration(hours: 2)),
    //totalMeal: 0,
    //totalMealCost: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    if (globals.lunchSelected != null && globals.lunchSelected.lunchId != 0) {
      lunch = globals.lunchSelected;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColorDark,
          ])),
          child: Column(
            children: <Widget>[
              //SizedBox(height: 40.0),
              Container(
                  margin: const EdgeInsets.all(5),
                  height: 128,
                  child: Image(
                    image: NetworkImage(
                        globals.restaurantSelected.restaurantUrlLogo),
                  )),
              FlatButton(
                padding: EdgeInsets.all(5),
                child: Image(
                  image: AssetImage('images/menu.png'),
                  width: 150,
                ),
                onPressed: () {
                  launch(globals.restaurantSelected.restaurantUrl);
                },
              ),
              Text(
                "Lunch organizer",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                globals.sessionLunch.username,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Company kitchen"),
                  Checkbox(
                    value: lunch.lunchType==0,
                    onChanged: (bool value) {
                      setState(() {
                        lunch.lunchType = value?0:1;
                      });
                    },
                  ),
                ],
              ),
              Form(
                  key: _formStateKey,
                  autovalidate: true,
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        hintText: "description",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      initialValue: lunch.lunchDescription,
                      onSaved: (value) => lunch.lunchDescription = value,
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          lunch.lunchOrderTime = time;
                          setState(() {});
                        }, currentTime: lunch.lunchOrderTime, locale: LocaleType.pl);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    ' we accept order until ${lunch.lunchOrderTime.hour} : ${lunch.lunchOrderTime.minute}',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          lunch.lunchLunchTime = time;
                          setState(() {});
                        }, currentTime: lunch.lunchLunchTime, locale: LocaleType.pl);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    ' lunch will be on ${lunch.lunchLunchTime.hour} : ${lunch.lunchLunchTime.minute}',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.white,
                            textColor: Colors.lightGreen,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Save".toUpperCase()),
                            onPressed: () {
                              saveLunch(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.white,
                            textColor: Colors.lightGreen,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Delete".toUpperCase()),
                            onPressed: () {
                              deleteLunch(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  Future saveLunch(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
    globals.lunchSelected = lunch;
    if (lunch.lunchId == 0) {
      // prepare JSON for request
      print('prepare JSON');
      LunchCreateRequest r = LunchCreateRequest(
          request: 'lunch.create',
          session: globals.sessionLunch.sessionId,
          arguments: LunchCreateArguments(
            restaurantId: globals.restaurantSelected.restaurantId,
            lunchType: lunch.lunchType,
            lunchDescription: lunch.lunchDescription,
            transportCost: lunch.transportCost.toString(),
            orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
            lunchTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
          )
      );
      print('request: '+r.toJson().toString());
      String reqJson = json.encode(r);
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool createRestaurant = res['createLunch'];
          if (createRestaurant) {
            Navigator.pop(context);
          } else {
            setState(() {
              message = res.toString();
            });
          }
        } else {
          setState(() {
            message = 'Bad request';
          });
        }
      } else {
        var res = result['error'];
        if (res != null) {
          setState(() {
            message = res.toString();
          });
        } else {
          setState(() {
            message = 'Bad request';
          });
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future deleteLunch(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
    globals.lunchSelected = lunch;
    if (lunch.lunchId != 0) {
      // prepare JSON for request
      String reqJson = json.encode(LunchDeleteRequest(
          request: 'lunch.delete',
          session: globals.sessionLunch.sessionId,
          arguments: LunchDeleteArguments(
            lunchId: globals.lunchSelected.lunchId,
          )));
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool deleteLunch = res['deleteLunch'];
          if (deleteLunch) {
            Navigator.pop(context);
          } else {
            setState(() {
              message = res.toString();
            });
          }
        } else {
          setState(() {
            message = 'Bad request';
          });
        }
      } else {
        var res = result['error'];
        if (res != null) {
          setState(() {
            message = res.toString();
          });
        } else {
          setState(() {
            message = 'Bad request';
          });
        }
      }
    }
  }
}

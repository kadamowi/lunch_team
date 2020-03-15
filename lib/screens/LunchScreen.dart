import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/data/RestaurantApi.dart';
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
    restaurantId: (globals.restaurantSelected != null)
        ? globals.restaurantSelected.restaurantId
        : 0,
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
      print('bulid Lunch Screen - lunchId: '+lunch.lunchId.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              FutureBuilder<Restaurant>(
                future: detailsRestaurant(lunch.restaurantId),
                builder:
                    (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ProgressBar();
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else
                      return Container(
                        margin: const EdgeInsets.all(5),
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: snapshot.data.restaurantUrlLogo),
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
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
                            child: Text(
                              'Lunch details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Company kitchen"),
                              Checkbox(
                                value: lunch.lunchType == 0,
                                onChanged: (bool value) {
                                  setState(() {
                                    lunch.lunchType = value ? 0 : 1;
                                  });
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'description',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            initialValue: lunch.lunchDescription,
                            onSaved: (value) => lunch.lunchDescription = value,
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'transport cost',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            initialValue: (lunch.transportCost > 0)?lunch.transportCost.toString():'',
                            onSaved: (value) => lunch.transportCost = double.tryParse(value),
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                          ),
                          SizedBox(height: 10.0),
                          DateTimeField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'lunch order to',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            format: DateFormat("HH:mm"),
                            initialValue: lunch.lunchOrderTime,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    lunch.lunchOrderTime),
                                builder: (context, child) => MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child),
                              );
                              lunch.lunchOrderTime = DateTimeField.combine(
                                  lunch.lunchOrderTime, time);
                              return DateTimeField.convert(time);
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          DateTimeField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'lunch time',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            format: DateFormat("HH:mm"),
                            initialValue: lunch.lunchLunchTime,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    lunch.lunchLunchTime),
                                builder: (context, child) => MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child),
                              );
                              lunch.lunchLunchTime = DateTimeField.combine(
                                  lunch.lunchLunchTime, time);
                              return DateTimeField.convert(time);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.orange[800],
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Save".toUpperCase()),
                            onPressed: () {
                              saveLunch(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RaisedButton(
                            color: Colors.orange[800],
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Delete".toUpperCase()),
                            onPressed: () {
                              deleteLunch(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    MessageError(message: message),
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
    } else
      return;

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
            transportCost: (lunch.transportCost??'0').toString(),
            orderTime:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
            lunchTime:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
          ));
      print('request: ' + r.toJson().toString());
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
      // prepare JSON for request
      LunchEditRequest r = LunchEditRequest(
        request: 'lunch.edit',
        session: globals.sessionLunch.sessionId,
        arguments: LunchEditArguments(
          lunchId: lunch.lunchId,
          restaurantId: lunch.restaurantId,
          lunchDescription: lunch.lunchDescription,
          lunchType: lunch.lunchType??0,
          transportCost: (lunch.transportCost??'0').toString(),
          orderTime:
          DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
          lunchTime:
          DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
        )
      );
      String reqJson = json.encode(r);
      // make POST request
      print('lunch.edit:'+reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool createRestaurant = res['editLunch'];
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


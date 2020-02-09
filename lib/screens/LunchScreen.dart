import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';

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
    lunchType: true,
    lunchDescription: 'i am hungry',
    transportCost: 0,
    orderTime: DateTime.now(),
    lunchTime: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    //final SessionLunch sessionLunch =
    //    ModalRoute.of(context).settings.arguments as SessionLunch;

    //if (globals.lunchSelected.lunchId != 0) {
    //  lunch = globals.lunchSelected;
    //}
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
              SizedBox(height: 40.0),
              Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  height: 128,
                  child: Image(
                    image: NetworkImage(globals.restaurantSelected.restaurantUrlLogo),
                  )),
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
    /*
    if (lunch.lunchId == 0) {
      // prepare JSON for request
      String reqJson = json.encode(RestaurantCreateRequest(
          request: 'restaurant.create',
          session: globals.sessionLunch.sessionId,
          arguments: RestaurantCreateArguments(
              restaurantName: globals.restaurantSelected.restaurantName,
              restaurantDescription:
              globals.restaurantSelected.restaurantDescription,
              restaurantUrl: globals.restaurantSelected.restaurantUrl,
              restaurantUrlLogo:
              globals.restaurantSelected.restaurantUrlLogo)));
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool createRestaurant = res['createRestaurant'];
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

     */
  }

  Future deleteLunch(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
    globals.lunchSelected = lunch;
    /*
    if (restaurant.restaurantId != 0) {
      // prepare JSON for request
      String reqJson = json.encode(RestaurantDeleteRequest(
          request: 'restaurant.delete',
          session: globals.sessionLunch.sessionId,
          arguments: RestaurantDeleteArguments(
            restaurantId: globals.restaurantSelected.restaurantId,
          )));
      // make POST request
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool deleteRestaurant = res['deleteRestaurant'];
          if (deleteRestaurant) {
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

     */
  }
}

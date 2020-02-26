import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Meal.dart';
import 'package:lunch_team/model/MealRequest.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  Meal meal = new Meal(
    mealId: 0,
    mealName: '',
    mealCost: 0,
  );

  String _validateDescription(String value) {
    return value.trim().length == 0 ? 'Description is empty' : null;
  }

  String _validateCost(String value) {
    double _value = value.isEmpty ? 0 : double.tryParse(value);
    if (_value <= 0) return 'Cost must be greater from 0';
    if (_value > 100) return 'Cost must be less then 100';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (globals.mealSelected.mealId != 0) {
      meal = globals.mealSelected;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Form(
                  key: _formStateKey,
                  autovalidate: false,
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
                      initialValue: meal.mealName,
                      validator: (value) => _validateDescription(value),
                      onSaved: (value) => meal.mealName = value.trim(),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        hintText: 'meal cost',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      initialValue: (meal.mealCost > 0)?meal.mealCost.toString():'',
                      validator: (value) => _validateCost(value),
                      onSaved: (value) =>
                          meal.mealCost = double.tryParse(value),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 30.0),
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
                              saveMeal(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
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
                              deleteMeal(context);
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

  Future saveMeal(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    } else return;
    globals.mealSelected = meal;
    if (meal.mealId == 0) {
      // prepare JSON for request
      String reqJson = json.encode(MealCreateRequest(
          request: 'meal.create',
          session: globals.sessionLunch.sessionId,
          arguments: MealCreateArguments(
            lunchId: globals.lunchSelected.lunchId,
            mealDescription: globals.mealSelected.mealName,
            mealCost: globals.mealSelected.mealCost.toString(),
          )));
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool createRestaurant = res['createMeal'];
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
      String reqJson = json.encode(MealEditRequest(
          request: 'restaurant.edit',
          session: globals.sessionLunch.sessionId,
          arguments: Meal()));
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(result);
        var res = result['response'];
        if (res != null) {
          bool editRestaurant = res['editMeal'];
          if (editRestaurant) {
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

  Future deleteMeal(BuildContext context) async {
    //if (_formStateKey.currentState.validate()) {
    //  _formStateKey.currentState.save();
    //}
    _formStateKey.currentState.save();
    globals.mealSelected = meal;
    if (meal.mealId != 0) {
      // prepare JSON for request
      String reqJson = json.encode(MealDeleteRequest(
          request: 'meal.delete',
          session: globals.sessionLunch.sessionId,
          arguments: MealDeleteArguments(
            mealId: globals.mealSelected.mealId,
          )));
      // make POST request
      print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var res = result['response'];
        if (res != null) {
          bool deleteRestaurant = res['deleteMeal'];
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
  }
}

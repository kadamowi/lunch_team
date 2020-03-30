import 'package:flutter/material.dart';
import 'package:lunch_team/data/MealApi.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Meal.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  Meal meal = new Meal(
    lunchId: globals.lunchSelected.lunchId,
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
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('Meal order',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),),
                          ),
                          SizedBox(height: 5.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: "description",
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
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
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            initialValue: (meal.mealCost > 0)?meal.mealCost.toString():'',
                            validator: (value) => _validateCost(value),
                            onSaved: (value) =>
                            meal.mealCost = double.tryParse(value),
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
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
                              if (_formStateKey.currentState.validate()) {
                                _formStateKey.currentState.save();
                                if (meal.mealId == 0) {
                                  createMeal(meal).then((value) {
                                    if (value == null) {
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        message = value;
                                      });
                                    }
                                  });
                                } else {
                                  editMeal(meal).then((value) {
                                    if (value == null) {
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        message = value;
                                      });
                                    }
                                  });
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
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
                              if (_formStateKey.currentState.validate()) {
                                _formStateKey.currentState.save();
                                if (meal.mealId > 0) {
                                  deleteMeal(meal.mealId).then((value) {
                                    if (value == null) {
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        message = value;
                                      });
                                    }
                                  });
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
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
}

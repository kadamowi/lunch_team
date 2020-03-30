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
import 'package:lunch_team/request/LunchRequest.dart';

class LunchScreen extends StatefulWidget {
  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  Lunch lunch = new Lunch(
    lunchId: 0,
    restaurantId: (globals.restaurantSelected != null) ? globals.restaurantSelected.restaurantId : globals.restaurantSets.keys.first,
    username: globals.sessionLunch.username,
    lunchType: 0,
    lunchDescription: '',
    transportCost: 0,
    lunchOrderTime: DateTime.now().add(Duration(hours: 1)),
    lunchLunchTime: DateTime.now().add(Duration(hours: 2)),
    //totalMeal: 0,
    //totalMealCost: 0.0,
    status: 'COLLECTING'
  );
  DateTime orderDate = DateTime.now();
  DateTime lunchDate = DateTime.now();

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentRestaurant;
  int _currentRestaurantId = 0;
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    globals.restaurantSets.values.forEach((v) => items.add(new DropdownMenuItem(value: v, child: new Text(v))));
    return items;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRestaurantId = lunch.restaurantId;
    _currentRestaurant = globals.restaurantSets[_currentRestaurantId]; //_dropDownMenuItems[0].value;
    _currentRestaurantId = globals.restaurantSets.keys.firstWhere((k) => globals.restaurantSets[k] == _currentRestaurant, orElse: () => null);
    super.initState();
  }

  void changedDropDownItem(String selectedRestaurant) {
    var key = globals.restaurantSets.keys.firstWhere((k) => globals.restaurantSets[k] == selectedRestaurant, orElse: () => null);
    if (key == null) key = 0;
    _currentRestaurantId = key;
    lunch.restaurantId = key;
    setState(() {
      _currentRestaurant = selectedRestaurant;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (globals.lunchSelected != null && globals.lunchSelected.lunchId != 0) {
      lunch = globals.lunchSelected;
      _currentRestaurantId = lunch.restaurantId;
      _currentRestaurant = globals.restaurantSets[_currentRestaurantId]; //_dropDownMenuItems[0].value;
      orderDate = lunch.lunchOrderTime;
      lunchDate = lunch.lunchLunchTime;
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
                future: detailsRestaurant(_currentRestaurantId),
                builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ProgressBar();
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else
                      return Container(
                        margin: const EdgeInsets.all(5),
                        //height: 200,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: CachedNetworkImage(placeholder: (context, url) => CircularProgressIndicator(), imageUrl: snapshot.data.restaurantUrlLogo),
                            ),
                            Visibility(
                              visible: snapshot.data.restaurantUrl.length > 0,
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                child: Image(
                                  image: AssetImage('images/menu.png'),
                                  height: 50,
                                ),
                                onPressed: () {
                                  launch(snapshot.data.restaurantUrl);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                  }
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
                          /*
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
                          */
                          Container(
                            //margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Restaurant: ',
                                  style: TextStyle(color: Colors.grey[800], fontSize: 16.0, fontWeight: FontWeight.bold),
                                ),
                                DropdownButton(
                                  value: _currentRestaurant,
                                  items: _dropDownMenuItems,
                                  onChanged: changedDropDownItem,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16.0,
                                    //fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'description',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              border: OutlineInputBorder(borderSide: BorderSide.none),
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
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            initialValue: (lunch.transportCost > 0) ? lunch.transportCost.toString() : '',
                            onSaved: (value) => lunch.transportCost = double.tryParse(value ?? "0.00"),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: Text('Collect'),
                                ),
                              ),
                              Container(
                                width: 140,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("yyyy-MM-dd"),
                                  initialValue: orderDate,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: orderDate,
                                        lastDate: DateTime(2100));
                                    orderDate = date;
                                    return date;
                                  },
                                ),
                              ),
                              Container(
                                width: 100,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    hintText: 'lunch order to',
                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("HH:mm"),
                                  initialValue: lunch.lunchOrderTime,
                                  onShowPicker: (context, currentValue) async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(lunch.lunchOrderTime),
                                      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
                                    );
                                    lunch.lunchOrderTime = DateTimeField.combine(lunch.lunchOrderTime, time);
                                    return DateTimeField.convert(time);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: Text('Lunch'),
                                ),
                              ),
                              Container(
                                width: 140,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("yyyy-MM-dd"),
                                  initialValue: lunchDate,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: lunchDate,
                                        lastDate: DateTime(2100));
                                    lunchDate = date;
                                    return date;
                                  },
                                ),
                              ),
                              Container(
                                width: 100,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    hintText: 'lunch time',
                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("HH:mm"),
                                  initialValue: lunch.lunchLunchTime,
                                  onShowPicker: (context, currentValue) async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(lunch.lunchLunchTime),
                                      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
                                    );
                                    lunch.lunchLunchTime = DateTimeField.combine(lunch.lunchLunchTime, time);
                                    return DateTimeField.convert(time);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: lunch.status == 'COLLECTING' || lunch.status == 'DELIVERING',
                      child: Row(
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

    lunch.lunchOrderTime = DateTime(
        orderDate.year,orderDate.month,orderDate.day,
        lunch.lunchOrderTime.hour,lunch.lunchOrderTime.minute);
    lunch.lunchLunchTime = DateTime(
        lunchDate.year,lunchDate.month,lunchDate.day,
        lunch.lunchLunchTime.hour,lunch.lunchLunchTime.minute);
    globals.lunchSelected = lunch;
    if (lunch.lunchId == 0) {
      // prepare JSON for request
      //print('prepare JSON');
      LunchCreateRequest r = LunchCreateRequest(
          request: 'lunch.create',
          session: globals.sessionLunch.sessionId,
          arguments: LunchCreateArguments(
            restaurantId: lunch.restaurantId,
            lunchType: lunch.lunchType,
            lunchDescription: lunch.lunchDescription,
            transportCost: (lunch.transportCost ?? '0.00').toString(),
            orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
            lunchTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
          ));
      //print('request: ' + r.toJson().toString());
      String reqJson = json.encode(r);
      // make POST request
      //print(reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      //print('statusCode:' + response.statusCode.toString());
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
            lunchType: lunch.lunchType ?? 0,
            transportCost: (lunch.transportCost ?? '0.00').toString(),
            orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
            lunchTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
          ));
      String reqJson = json.encode(r);
      // make POST request
      //print('lunch.edit:'+reqJson);
      Response response = await post(urlApi, headers: headers, body: reqJson);
      //print('statusCode:' + response.statusCode.toString());
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

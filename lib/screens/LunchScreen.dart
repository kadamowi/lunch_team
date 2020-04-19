import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lunch_team/data/LunchApi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/data/RestaurantApi.dart';
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
      restaurantId: (globals.restaurantSelected != null) ? globals.restaurantSelected.restaurantId : globals.restaurantSets.keys.first,
      username: globals.sessionUser,
      lunchType: 0,
      lunchDescription: '',
      transportCost: 0,
      lunchOrderTime: DateTime.now().add(Duration(hours: 1)),
      lunchLunchTime: DateTime.now().add(Duration(hours: 2)),
      status: 'COLLECTING');
  DateTime orderDate = DateTime.now().add(Duration(hours: 1));
  DateTime lunchDate = DateTime.now().add(Duration(hours: 2));

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
                            child: Text(
                              'Lunch details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
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
                                Spacer(),
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
                            validator: (value) {
                              if (value.length == 0) return "description is empty";
                              return null;
                            },
                            onSaved: (value) => lunch.lunchDescription = value.trim(),
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
                            validator: (value) {
                              if (double.tryParse(value ?? "0.00") < 0) return "cost must be >= 0";
                              if (double.tryParse(value ?? "0.00") > 100) return "cost too big";
                              return null;
                            },
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
                                width: 200,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("yyyy-MM-dd HH:mm"),
                                  initialValue: lunch.lunchOrderTime,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        initialDate: lunch.lunchOrderTime,
                                        firstDate: lunch.lunchOrderTime,
                                        lastDate: DateTime(2100)
                                    );
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(lunch.lunchOrderTime),
                                        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
                                      );
                                      lunch.lunchOrderTime = DateTimeField.combine(date, time);
                                      return lunch.lunchOrderTime;
                                    } else {
                                      return lunch.lunchOrderTime;
                                    }
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
                                width: 200,
                                child: DateTimeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  format: DateFormat("yyyy-MM-dd HH:mm"),
                                  initialValue: lunch.lunchLunchTime,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(context: context, initialDate: lunch.lunchLunchTime, firstDate: DateTime(2000), lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(lunch.lunchLunchTime),
                                        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
                                      );
                                      lunch.lunchLunchTime = DateTimeField.combine(date, time);
                                      return lunch.lunchLunchTime;
                                    } else {
                                      return lunch.lunchLunchTime;
                                    }
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
                                if (_formStateKey.currentState.validate()) {
                                  _formStateKey.currentState.save();
                                  globals.lunchSelected = lunch;
                                  if (lunch.lunchId == 0) {
                                    createLunch(lunch).then((value) {
                                      if (value == null) {
                                        Navigator.pop(context);
                                      } else {
                                        setState(() {
                                          message = value;
                                        });
                                      }
                                    });
                                  } else {
                                    editLunch(lunch).then((value) {
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
                                  if (lunch.lunchId > 0) {
                                    deleteLunch(lunch.lunchId).then((value) {
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
}

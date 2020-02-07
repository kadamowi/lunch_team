import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/RestaurantRequest.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String message = "";
  Restaurant restaurant = new Restaurant(
    restaurantId: '0',
    restaurantName: '',
    restaurantDescription: '',
    restaurantUrl: '',
    restaurantUrlLogo: '',
  );

  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch =
        ModalRoute.of(context).settings.arguments as SessionLunch;

    if (globals.restaurantSelected.restaurantId != '0') {
      restaurant = globals.restaurantSelected;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
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
                    image: NetworkImage('https://logodix.com/logo/307015.png'),
                  )),
              Form(
                  key: _formStateKey,
                  autovalidate: true,
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        hintText: "name",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      initialValue: restaurant.restaurantName,
                      onSaved: (value) => restaurant.restaurantName = value,
                    ),
                    SizedBox(height: 10.0),
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
                      initialValue: restaurant.restaurantDescription,
                      onSaved: (value) =>
                          restaurant.restaurantDescription = value,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        hintText: "URL",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      initialValue: restaurant.restaurantUrl,
                      onSaved: (value) => restaurant.restaurantUrl = value,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        hintText: "logo URL",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                      initialValue: restaurant.restaurantUrlLogo,
                      onSaved: (value) => restaurant.restaurantUrlLogo = value,
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        color: Colors.white,
                        textColor: Colors.lightGreen,
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Save".toUpperCase()),
                        onPressed: () {
                          saveRestaurant(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
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

  Future saveRestaurant(BuildContext context) async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
    }
    globals.restaurantSelected = restaurant;
    // prepare JSON for request
    String reqJson = json.encode(RestaurantCreateRequest(
        request: 'restaurant.create',
        session: globals.sessionLunch.sessionId,
        arguments: RestaurantCreateArguments(
            restaurantName: globals.restaurantSelected.restaurantName,
            restaurantDescription:
                globals.restaurantSelected.restaurantDescription,
            restaurantUrl: globals.restaurantSelected.restaurantUrl,
            restaurantUrlLogo: globals.restaurantSelected.restaurantUrlLogo)));
    // make POST request
    print(reqJson);
    Response response = await post(urlApi, headers: headers, body: reqJson);
    if (response.statusCode == 200){
      Navigator.pop(context);
    } else {
      print('statusCode:' + response.statusCode.toString());
      var result = jsonDecode(response.body);
      var res = result['response'];
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

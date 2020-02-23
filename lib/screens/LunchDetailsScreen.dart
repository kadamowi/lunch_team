import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lunch_team/model/Restaurant.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/LunchRequest.dart';
import 'package:lunch_team/data/RestaurantApi.dart';

class LunchDetailsScreen extends StatefulWidget {
  @override
  _LunchDetailsScreenState createState() => _LunchDetailsScreenState();
}

class _LunchDetailsScreenState extends State<LunchDetailsScreen> {
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Details'),
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
              FutureBuilder<Restaurant>(
                future: detailsRestaurant(globals.lunchSelected.restaurantId),
                builder: (BuildContext context,
                    AsyncSnapshot<Restaurant> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        margin: const EdgeInsets.all(5),
                        height: 128,
                        child: CachedNetworkImage(
                            placeholder: (context, url) => CircularProgressIndicator(),
                            imageUrl: snapshot.data.restaurantUrlLogo
                        ),
                        //Image(
                        //  image: NetworkImage(
                        //      snapshot.data.restaurantUrlLogo),
                        //)
                    );
                  } else {
                    return Text('Lipa');
                  }
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: Colors.lightGreen,
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Save".toUpperCase()),
                      onPressed: () {},
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
                      onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}

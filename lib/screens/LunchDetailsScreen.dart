import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/Meal.dart';
import 'package:lunch_team/screens/MealScreen.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/data/RestaurantApi.dart';
import 'package:lunch_team/data/MealApi.dart';

class LunchDetailsScreen extends StatefulWidget {
  @override
  _LunchDetailsScreenState createState() => _LunchDetailsScreenState();
}

class _LunchDetailsScreenState extends State<LunchDetailsScreen> {
  String message = "";

  Future<Null> refreshList() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder<Restaurant>(
              future: detailsRestaurant(globals.lunchSelected.restaurantId),
              builder:
                  (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    height: 100,
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: snapshot.data.restaurantUrlLogo),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(snapshot.data.restaurantName,
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    'Host: ' + globals.lunchSelected.username,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    'Order time: ' +
                                        DateFormat('HH:mm').format(globals
                                            .lunchSelected.lunchOrderTime),
                                    style: TextStyle(color: Colors.red)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text('Lunch time: ' +
                                    DateFormat('HH:mm').format(
                                        globals.lunchSelected.lunchLunchTime)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('No restauraunt information');
                }
              },
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Text(globals.lunchSelected.lunchDescription),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Orders:',
                      style: TextStyle(
                        //color: Colors.yellowAccent,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total lunch cost '+globals.lunchSelected.lunchCost.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ),
            Expanded(
              child: FutureBuilder<List<Meal>>(
                  future: fetchMealList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Meal>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else
                        return RefreshIndicator(
                          onRefresh: refreshList,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(5),
                                //padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          snapshot.data[index].mealName,
                                          style: TextStyle(
                                              color: Colors.orange[800],
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(snapshot
                                                .data[index].mealCost
                                                .toStringAsFixed(2))),
                                      )
                                    ],
                                  ),
                                  subtitle: Text(snapshot.data[index].username),
                                  onTap: () {
                                    if (snapshot.data[index].username == globals.sessionLunch.username) {
                                      globals.mealSelected = snapshot.data[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MealScreen(),
                                        ),
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: Text('It is not your order !!!'),
                                            //content: new Text("Alert Dialog body"),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              new FlatButton(
                                                child: new Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                    }
                  }),
            ),
            SizedBox(
              height: 40,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globals.mealSelected = Meal(
            mealId: 0,
            lunchId: globals.lunchSelected.lunchId,
            mealName: '',
            mealCost: 0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealScreen(),
            ),
          );
        },
        tooltip: 'Add lunch order',
        child: Icon(Icons.add),
      ),
    );
  }
}

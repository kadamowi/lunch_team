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
        padding: const EdgeInsets.all(16.0),
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
                        CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: snapshot.data.restaurantUrlLogo),
                        Column(
                          children: <Widget>[
                            Text(snapshot.data.restaurantName,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  'Host: ' + globals.lunchSelected.username,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(
                                'Order time: ' +
                                    DateFormat('HH:mm').format(
                                        globals.lunchSelected.lunchOrderTime),
                                style: TextStyle(color: Colors.red)),
                            Text('Lunch time: ' +
                                DateFormat('HH:mm').format(
                                    globals.lunchSelected.lunchLunchTime)),
                          ],
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
              child: Text(globals.lunchSelected.lunchDescription),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<Meal>>(
                  future: fetchMealList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Meal>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('loading');
                      return Center(child: Text('Please wait its loading...'));
                    } else {
                      if (snapshot.hasError) {
                        print('error');
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else
                        return RefreshIndicator(
                          onRefresh: refreshList,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return RaisedButton(
                                color: Colors.limeAccent,
                                //textColor: Colors.white,
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Text(snapshot
                                                  .data[index].username +
                                              ' - ' +
                                              snapshot.data[index].mealName),
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
                                ),
                                onPressed: () {
                                  globals.mealSelected = snapshot.data[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MealScreen(),
                                    ),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
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

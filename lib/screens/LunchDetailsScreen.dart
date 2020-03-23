import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lunch_team/data/LunchApi.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Meal.dart';
import 'package:lunch_team/screens/MealScreen.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/data/MealApi.dart';

class LunchDetailsScreen extends StatefulWidget {
  @override
  _LunchDetailsScreenState createState() => _LunchDetailsScreenState();
}

class _LunchDetailsScreenState extends State<LunchDetailsScreen> {
  String message = "X";

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
        //height: MediaQuery.of(context).size.height,
        //width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder<Lunch>(
              future: lunchDeetails(globals.lunchSelected.lunchId),
              builder: (BuildContext context, AsyncSnapshot<Lunch> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ProgressBar();
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Container(
                        margin: const EdgeInsets.all(5),
                        //alignment: Alignment.topLeft,
                        height: MediaQuery.of(context).size.height - 150,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: 100,
                                      child: CachedNetworkImage(placeholder: (context, url) => CircularProgressIndicator(), imageUrl: snapshot.data.restaurantLogo),
                                    )),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(snapshot.data.restaurantName, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('Host: ' + snapshot.data.username, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('Order time: ' + DateFormat('HH:mm').format(snapshot.data.lunchOrderTime), style: TextStyle(color: Colors.red)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('Lunch time: ' + DateFormat('HH:mm').format(snapshot.data.lunchLunchTime)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(5),
                              child: Image(
                                image: AssetImage('images/menu.png'),
                                height: 50,
                              ),
                              onPressed: () {
                                launch(snapshot.data.restaurantUrl);
                              },
                            ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width,
                              child: Text(snapshot.data.lunchDescription),
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
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder<List<Meal>>(
                                  future: fetchMealList(snapshot.data.lunchId),
                                  builder: (BuildContext context, AsyncSnapshot<List<Meal>> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return ProgressBar();
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
                                                  color: (snapshot.data[index].settled) ? Colors.orange[50] : Colors.white,
                                                ),
                                                child: ListTile(
                                                  title: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          snapshot.data[index].mealName,
                                                          style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Align(alignment: Alignment.centerRight, child: Text(snapshot.data[index].mealCost.toStringAsFixed(2))),
                                                      )
                                                    ],
                                                  ),
                                                  subtitle: Text(snapshot.data[index].username + ((snapshot.data[index].settled) ? ' - rozliczone' : '')),
                                                  onTap: () {
                                                    // User kliknął na swoje zamówienie
                                                    if (snapshot.data[index].userId == globals.userLogged.userId) {
                                                      // Czy jest jeszcze czas
                                                      if (globals.lunchSelected.lunchOrderTime.difference(DateTime.now()).inMinutes >= 0) {
                                                        globals.mealSelected = snapshot.data[index];
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => MealScreen(),
                                                          ),
                                                        ).then((value) {
                                                          setSettled(snapshot.data[index].mealId);
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            // return object of type Dialog
                                                            return AlertDialog(
                                                              title: Text('It is to late, maybe next time'),
                                                              actions: <Widget>[
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
                                                    } else {
                                                      // Czy to jest właściciel Lunch
                                                      if (globals.userLogged.userId == globals.lunchSelected.userId) {
                                                        print('Właściciel kliknął na rozliczenie');
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            // return object of type Dialog
                                                            return AlertDialog(
                                                              title: Text('Do you accepte settlement ?'),
                                                              actions: <Widget>[
                                                                new FlatButton(
                                                                  child: new Text("Yes"),
                                                                  onPressed: () {
                                                                    setSettled(snapshot.data[index].mealId).then((value) {
                                                                      setState(() {
                                                                        Navigator.of(context).pop();
                                                                      });
                                                                    });
                                                                  },
                                                                ),
                                                                new FlatButton(
                                                                  child: new Text("No"),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
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
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Summary',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(10.0),
                              //width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 150,
                                        child: Text('Orders'),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            snapshot.data.lunchCost.toStringAsFixed(2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 150,
                                        child: Text('Transport'),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            snapshot.data.transportCost.toStringAsFixed(2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          'Total lunch cost',
                                          style: TextStyle(
                                              //fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            (snapshot.data.lunchCost + snapshot.data.transportCost).toStringAsFixed(2),
                                            style: TextStyle(
                                                //fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  }
                }
              },
            ),

            //Spacer(),
            //MessageError(message: message),
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
          //print('lunchOrderTime:'+globals.lunchSelected.lunchOrderTime.toString());
          //print('difference:'+globals.lunchSelected.lunchOrderTime.difference(DateTime.now()).inMinutes.toString());
          if (globals.lunchSelected.lunchOrderTime.difference(DateTime.now()).inMinutes >= 0) {
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
                  title: Text('It is to late, maybe next time'),
                  actions: <Widget>[
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
        tooltip: 'Add lunch order',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

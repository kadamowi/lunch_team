import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/data/LunchApi.dart';
import 'package:lunch_team/screens/LunchScreen.dart';
import 'package:lunch_team/screens/LunchDetailsScreen.dart';

class LunchListScreen extends StatefulWidget {
  @override
  _LunchListScreenState createState() => _LunchListScreenState();
}

class _LunchListScreenState extends State<LunchListScreen> {
  bool onlyMyMeal = false;
  bool onlyMyLunch = false;

  Future<Null> refreshList() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Lunch list'),
      //),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Lunch>>(
                  future: lunchList(globals.dateFrom, globals.dateTo, onlyMyMeal, onlyMyLunch),
                  builder: (BuildContext context, AsyncSnapshot<List<Lunch>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ProgressBar();
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        return RefreshIndicator(
                          onRefresh: refreshList,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100,
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Badge(
                                  shape: BadgeShape.square,
                                  borderRadius: 5,
                                  toAnimate: true,
                                  badgeContent: Text(snapshot.data[index].mealCount.toString(), style: TextStyle(color: Colors.white)),
                                  badgeColor: Colors.orange[800],
                                  padding: EdgeInsets.all(8),
                                  child: FlatButton(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            height: 100,
                                            margin: const EdgeInsets.all(0),
                                            color: globals.statusColors[snapshot.data[index].status],
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: Text(
                                                globals.statusDesc[snapshot.data[index].status],
                                                style: TextStyle(
                                                  backgroundColor: globals.statusColors[snapshot.data[index].status],
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 70,
                                            width: 70,
                                            child: CachedNetworkImage(placeholder: (context, url) => CircularProgressIndicator(), imageUrl: snapshot.data[index].restaurantLogo),
                                          ),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                  child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  snapshot.data[index].restaurantName,
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    snapshot.data[index].lunchDescription,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.person),
                                                  Text(
                                                    snapshot.data[index].username,
                                                    style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold),
                                                  ),
                                                  //Align(
                                                  //  alignment:
                                                  //  Alignment.topLeft,
                                                  //  child:
                                                  //),
                                                  Spacer(),
                                                  Visibility(
                                                    visible: (snapshot.data[index].status == 'COLLECTING'),
                                                    child: Icon(Icons.timer),
                                                  ),
                                                  Visibility(
                                                    visible: (snapshot.data[index].status == 'DELIVERING'),
                                                    child: Icon(Icons.directions_car),
                                                  ),
                                                  Visibility(
                                                    visible: (snapshot.data[index].status == 'COLLECTING'),
                                                    child: Text(
                                                      //@todo: Dorobić formatowanie w postaci hh:mm
                                                      snapshot.data[index].lunchOrderTime.difference(DateTime.now()).inMinutes.toString(),
                                                      style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (snapshot.data[index].status == 'DELIVERING'),
                                                    child: Text(
                                                      //@todo: Dorobić formatowanie w postaci hh:mm
                                                      snapshot.data[index].lunchLunchTime.difference(DateTime.now()).inMinutes.toString(),
                                                      style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      onPressed: () {
                                        globals.lunchSelected = snapshot.data[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LunchDetailsScreen(),
                                          ),
                                        );
                                      },
                                      onLongPress: () {
                                        print(snapshot.data[index].userId.toString()+' '+globals.userLogged.userId.toString());
                                        if (snapshot.data[index].userId == globals.userLogged.userId) {
                                          globals.lunchSelected = snapshot.data[index];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LunchScreen(),
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
                                                title: Text('You are not an organizer !!!'),
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
                                      }),
                                ),
                              );
                            },
                          ),
                        );
                    }
                  }),
            ),
            /*
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                //border: Border.all(),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DateTimeField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16.0),
                      hintText: 'date from',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    format: DateFormat("yyyy-MM-dd"),
                    initialValue: globals.dateFrom,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(context: context, firstDate: DateTime(2020), initialDate: globals.dateFrom, lastDate: DateTime(2100));
                      setState(() {
                        globals.dateFrom = date;
                      });
                      return date;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DateTimeField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16.0),
                      hintText: 'date to',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    format: DateFormat("yyyy-MM-dd"),
                    initialValue: globals.dateTo,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(context: context, firstDate: DateTime(2020), initialDate: globals.dateTo, lastDate: DateTime(2100));
                      setState(() {
                        globals.dateTo = date;
                      });
                      return date;
                    },
                  ),
                ],
              ),
            ),
             */
            MessageError(message: globals.errorMessage),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globals.lunchSelected = new Lunch(lunchId: 0);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LunchScreen(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Add lunch',
        child: Icon(Icons.add),
      ),
    );
  }
}

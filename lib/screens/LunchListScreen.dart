import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
  DateTime dateFrom = DateTime.now().add(Duration(days: -7));
  DateTime dateTo = DateTime.now();
  bool onlyMyMeal = false;
  bool onlyMyLunch = false;

  Future<Null> refreshList() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch list'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
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
                    child: Text('Filters'),
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
                    initialValue: dateFrom,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          initialDate: dateFrom,
                          lastDate: DateTime(2100)
                      );
                      setState(() {
                        dateFrom = date;
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
                    initialValue: dateTo,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          initialDate: dateTo,
                          lastDate: DateTime(2100)
                      );
                      setState(() {
                        dateTo = date;
                      });
                      return date;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Lunch>>(
                  future: lunchList(dateFrom, dateTo, onlyMyMeal, onlyMyLunch),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Lunch>> snapshot) {
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
                                //height: 100,
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
/*                                  border: Border.all(),*/
                                  color: Colors.white,
                                ),
                                child: Badge(
                                  badgeContent: Text(snapshot
                                      .data[index].mealCount
                                      .toString()),
                                  badgeColor: Colors.orange[50],
                                  padding: EdgeInsets.all(8),
                                  child: ListTile(
                                      trailing: Icon(
                                        (snapshot.data[index].status ==
                                                'COLLECTING')
                                            ? Icons.create_new_folder
                                            : (snapshot.data[index].status ==
                                                    'DELIVERING')
                                                ? Icons.directions_car
                                                : (snapshot.data[index]
                                                            .status ==
                                                        'TO_SETTLEMENT')
                                                    ? Icons.attach_money
                                                    : (snapshot.data[index]
                                                                .status ==
                                                            'SETTLEMENTED')
                                                        ? Icons.money_off
                                                        : Icons.error,
                                        color: Colors.orange[800],
                                      ),
                                      title: Text(
                                        snapshot.data[index].restaurantName +
                                            ' - ' +
                                            snapshot.data[index].username,
                                        style: TextStyle(
                                            color: Colors.orange[800],
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Container(
                                        height: 50,
                                        child: Text(
                                          snapshot.data[index].lunchDescription,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                      onTap: () {
                                        globals.lunchSelected =
                                            snapshot.data[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LunchDetailsScreen(),
                                          ),
                                        );
                                      },
                                      onLongPress: () {
                                        if (snapshot.data[index].username ==
                                            globals.sessionLunch.username) {
                                          globals.lunchSelected =
                                              snapshot.data[index];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LunchScreen(),
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
                                                title: Text(
                                                    'You are not an organizer !!!'),
                                                //content: new Text("Alert Dialog body"),
                                                actions: <Widget>[
                                                  // usually buttons at the bottom of the dialog
                                                  new FlatButton(
                                                    child: new Text("Close"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
            MessageError(message: globals.errorMessage),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LunchScreen(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Add restaurant',
        child: Icon(Icons.add),
      ),
    );
  }
}

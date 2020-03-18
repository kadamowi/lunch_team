import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:badges/badges.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/LunchRequest.dart';
import 'package:lunch_team/screens/LunchScreen.dart';
import 'package:lunch_team/screens/LunchDetailsScreen.dart';

class LunchListScreen extends StatefulWidget {
  @override
  _LunchListScreenState createState() => _LunchListScreenState();
}

class _LunchListScreenState extends State<LunchListScreen> {
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
            Expanded(
              child: FutureBuilder<List<Lunch>>(
                  future: downloadData(),
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
                                        Icons.fastfood,
                                        color: Colors.orange[800],
                                      ),
                                      title: Text(
                                        snapshot.data[index].restaurantName +
                                            ' - ' +
                                            snapshot.data[index].username +
                                            ' (' +
                                            snapshot.data[index].status +
                                            ')',
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
          ],
        ),
      ),
    );
  }

  Future<List<Lunch>> downloadData() async {
    // prepare JSON for request
    String reqJson = json.encode(LunchListRequest(
        request: 'lunch.list', session: globals.sessionLunch.sessionId));
    // make POST request
    Response response = await post(urlApi, headers: headers, body: reqJson);
    var result = jsonDecode(response.body);
    var resp = result['response'];
    var l = resp['lunches'];
    //print(l.toString());
    var lunches = l.map((i) => Lunch.fromJson(i)).toList();
    List<Lunch> lunchList = new List<Lunch>();
    for (Lunch lunch in lunches) {
      lunchList.add(lunch);
    }
    return lunchList;
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/LunchRequest.dart';

class LunchListScreen extends StatefulWidget {
  @override
  _LunchListScreenState createState() => _LunchListScreenState();
}

class _LunchListScreenState extends State<LunchListScreen> {
  @override
  Widget build(BuildContext context) {
    //final SessionLunch sessionLunch =
    //ModalRoute.of(context).settings.arguments as SessionLunch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch list'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorDark,
            ])),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Lunch>>(
                  future: downloadData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Lunch>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...'));
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.amber,
                              ),
                              child: ListTile(
                                  trailing: Icon(
                                    Icons.fastfood,
                                    color: Colors.blue,
                                  ),
                                  title:
                                  Text(
                                    snapshot.data[index].restaurantName + ' - '+
                                    snapshot.data[index].username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Container(
                                    height: 50,
                                    child: Text(
                                      snapshot.data[index].lunchDescription,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  onTap: () {
                                  },
                                  onLongPress: () {
                                  }
                              ),
                            );
                          },
                        );
                    }
                  }),
            ),
            //Spacer(),
            SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.lightGreen,
                child: Text("Refresh"),
                onPressed: () {
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            SizedBox(height: 20.0),
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

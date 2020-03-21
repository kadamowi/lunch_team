import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/TeamUsersRequest.dart';
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/User.dart';
import 'package:lunch_team/model/globals.dart' as globals;

class HungerListScreen extends StatefulWidget {
  @override
  _HungerListScreenState createState() => _HungerListScreenState();
}

class _HungerListScreenState extends State<HungerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Hunger list'),
      //),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<String>>(
                  future: downloadData(globals.sessionLunch),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ProgressBar();
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
                              //height: 50,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                /*border: Border.all(),*/
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Text(
                                    snapshot.data[index],
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                            );
                          },
                        );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> downloadData(SessionLunch sessionLunch) async {
    // prepare JSON for request
    String reqJson = json.encode(TeamUsersRequest(
        request: 'user.list', session: sessionLunch.sessionId));
    // make POST request
    Response response = await post(urlApi, headers: headers, body: reqJson);
    var result = jsonDecode(response.body);
    var resp = result['response'];
    var u = resp['users'];
    //print(u.toString());
    var users = u.map((i) => User.fromJson(i)).toList();
    List<String> userList = new List<String>();
    for (User user in users) {
      //print(user.username);
      userList.add(user.username);
    }
    return userList;
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:lunch_team/model/Lunch.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/RestaurantRequest.dart';
import 'package:lunch_team/screens/RestaurantScreen.dart';
import 'package:lunch_team/screens/LunchScreen.dart';

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch =
        ModalRoute.of(context).settings.arguments as SessionLunch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant list'),
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
              child: FutureBuilder<List<Restaurant>>(
                  future: downloadData(sessionLunch),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Restaurant>> snapshot) {
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
                                  leading: Image(
                                    image: NetworkImage(
                                        snapshot.data[index].restaurantUrlLogo),
                                  ),
                                  trailing: Icon(
                                    Icons.fastfood,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    snapshot.data[index].restaurantName +
                                        ' (' +
                                        snapshot.data[index].lunchCount
                                            .toString() +
                                        ')',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Container(
                                    height: 50,
                                    child: Text(
                                      snapshot
                                          .data[index].restaurantDescription,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  onTap: () {
                                    globals.restaurantSelected =
                                        snapshot.data[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LunchScreen(),
                                          settings: RouteSettings(
                                            arguments: sessionLunch,
                                          )),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  onLongPress: () {
                                    globals.restaurantSelected =
                                        snapshot.data[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantScreen(),
                                          settings: RouteSettings(
                                            arguments: sessionLunch,
                                          )),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globals.restaurantSelected = Restaurant(
            restaurantId: 0,
            restaurantName: '',
            restaurantDescription: '',
            restaurantUrl: '',
            restaurantUrlLogo: '',
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantScreen(),
                settings: RouteSettings(
                  arguments: sessionLunch,
                )),
          );
        },
        tooltip: 'Add restaurant',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Restaurant>> downloadData(SessionLunch sessionLunch) async {
    // prepare JSON for request
    String reqJson = json.encode(RestaurantListRequest(
        request: 'restaurant.list', session: sessionLunch.sessionId));
    // make POST request
    Response response = await post(urlApi, headers: headers, body: reqJson);
    var result = jsonDecode(response.body);
    var resp = result['response'];
    var u = resp['restaurants'];
    //print(u.toString());
    var restaurants = u.map((i) => Restaurant.fromJson(i)).toList();
    List<Restaurant> restaurantList = new List<Restaurant>();
    for (Restaurant restaurant in restaurants) {
      //print(user.username);
      restaurantList.add(restaurant);
    }
    return restaurantList;
  }
}

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lunch_team/data/RestaurantApi.dart';
import 'package:lunch_team/model/Lunch.dart';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/screens/RestaurantScreen.dart';
import 'package:lunch_team/screens/LunchScreen.dart';

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  Future<Null> refreshList() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant list'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        //decoration: BoxDecoration(
        //    gradient: LinearGradient(colors: [
        //  Theme.of(context).primaryColorLight,
        //  Theme.of(context).primaryColorDark,
        //])
        //),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Restaurant>>(
                  future: restaurantList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Restaurant>> snapshot) {
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
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  /*border: Border.all(),*/
                                  color: Colors.white,
                                ),
                                child: Badge(
                                    badgeContent: Text(
                                        snapshot.data[index].lunchCount.toString()
                                    ),
                                    badgeColor: Colors.orange[50],
                                    padding: EdgeInsets.all(8),
                                    child: ListTile(
                                        leading: Container(
                                          width: 60,
                                          height: 60,
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              imageUrl: snapshot.data[index]
                                                  .restaurantUrlLogo),
                                        ),
                                        trailing: Icon(
                                          Icons.fastfood,
                                          color: Colors.orange[800],
                                        ),
                                        title: Text(
                                          snapshot.data[index].restaurantName,
                                          style: TextStyle(
                                              color: Colors.orange[800],
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Container(
                                          height: 50,
                                          child: Text(
                                              snapshot.data[index]
                                                  .restaurantDescription,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.grey[800])),
                                        ),
                                        onTap: () {
                                          globals.restaurantSelected =
                                              snapshot.data[index];
                                          globals.lunchSelected = Lunch(
                                            lunchId: 0,
                                            lunchDescription: '',
                                            lunchType: 0,
                                            lunchOrderTime: DateTime.now()
                                                .add(new Duration(hours: 1)),
                                            lunchLunchTime: DateTime.now()
                                                .add(new Duration(hours: 2)),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LunchScreen(),
                                            ),
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
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        })),
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
            ),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Add restaurant',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

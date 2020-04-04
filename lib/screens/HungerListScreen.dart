import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lunch_team/widgets/LunchTeamWidget.dart';
import 'package:lunch_team/model/User.dart';
import 'package:lunch_team/data/UserApi.dart';

class HungerListScreen extends StatefulWidget {
  @override
  _HungerListScreenState createState() => _HungerListScreenState();
}

class _HungerListScreenState extends State<HungerListScreen> {
  Future<Null> refreshList() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<User>>(
                  future: userList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> snapshot) {
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
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    child: (snapshot.data[index].avatarUrl.length>0)?CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        imageUrl: snapshot.data[index].avatarUrl
                                            ):Image(
                                      image: AssetImage('images/avatar.png'),
                                    ),
                                  ),
                                    title: Text(
                                      snapshot.data[index].displayName,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          //fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  subtitle: Text(
                                    snapshot.data[index].username,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        //fontSize: 20.0,
                                        //fontWeight: FontWeight.bold
                                    ),
                                  ),
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
}

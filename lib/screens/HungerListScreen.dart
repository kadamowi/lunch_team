import 'package:flutter/material.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';

final List<String> teamUsers = ['Stefan', 'Marian', 'Gennowefa'];

class HungerListScreen extends StatefulWidget {
  @override
  _HungerListScreenState createState() => _HungerListScreenState();
}

class _HungerListScreenState extends State<HungerListScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch =
        ModalRoute.of(context).settings.arguments as SessionLunch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hunger list'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColorLight,
          Theme.of(context).primaryColorDark,
        ])),
        child: Column(
          children: <Widget>[
            Text(
              "List of people who like to eat in a band",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: teamUsers.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.amber,
                  ),
                  child: Center(
                      child: Text(
                        teamUsers[index],
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )
                  ),
                );
              },
            ),
            //Spacer(),
          ],
        ),
      ),
    );
  }
}

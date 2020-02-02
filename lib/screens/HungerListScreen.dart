import 'package:flutter/material.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';

class HungerListScreen extends StatefulWidget {
  @override
  _HungerListScreenState createState() => _HungerListScreenState();
}

class _HungerListScreenState extends State<HungerListScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch = ModalRoute.of(context).settings.arguments as SessionLunch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hunger list'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [
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
          ],
        ),
      ),
    );
  }
}

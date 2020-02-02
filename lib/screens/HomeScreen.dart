import 'package:flutter/material.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch = ModalRoute.of(context).settings.arguments as SessionLunch;
    //var sessionLunch = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Team'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.lightGreen, Colors.green])),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              height: 100,
              child: Image(
                image: AssetImage('images/LunchTeam.png'),
              ),
            ),
            Text(
              "Lunch Team",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Logged: " +
                  sessionLunch.username +
                  " (sessionId:" +
                  sessionLunch.sessionId.substring(1, 10) +
                  ")",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Center(
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.lightGreen,
                child: Text("Hunger list"),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            Center(child: Container()),
            Center(child: Container())
          ],
        ),
      ),
    );
  }
}

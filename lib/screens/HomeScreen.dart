import 'package:flutter/material.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final SessionLunch sessionLunch = ModalRoute.of(context).settings.arguments as SessionLunch;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Team'),
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
            Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Colors.lightGreen,
                    child: Text("Organize lunch"),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Colors.lightGreen,
                    child: Text("Lunches"),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Colors.lightGreen,
                    child: Text("Hunger list"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HungerListScreen(),
                            settings: RouteSettings(
                              arguments: sessionLunch,
                            )),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:lunch_team/screens/RestaurantListScreen.dart';
import 'package:lunch_team/screens/LunchListScreen.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'package:lunch_team/model/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Team'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(globals.sessionLunch.username),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              height: 200,
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                color: Colors.orange[800],
                textColor: Colors.white,
                child: Text("Restaurants"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantListScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                color: Colors.orange[800],
                textColor: Colors.white,
                child: Text("Lunches"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LunchListScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                color: Colors.orange[800],
                textColor: Colors.white,
                child: Text("Hunger list"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HungerListScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RaisedButton(
                color: Colors.grey[800],
                textColor: Colors.white,
                child: Text("Logout"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            FutureBuilder<PackageInfo>(
                future: loadPackageInfo(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return Text('Version ' + snapshot.data.version);
                  else
                    return Text('Version');
                })
          ],
        ),
      ),
    );
  }

  Future<PackageInfo> loadPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info;
  }
}

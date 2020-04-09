import 'package:flutter/material.dart';
import 'package:lunch_team/data/LunchApi.dart';
import 'package:lunch_team/screens/LunchDetailsScreen.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';
import 'package:lunch_team/screens/LunchListScreen.dart';
import 'package:lunch_team/screens/RestaurantListScreen.dart';
import 'package:lunch_team/screens/UserDetailsScreen.dart';
import 'package:lunch_team/model/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  int _currentIndex = 0;
  final List<Widget> _children = [
    LunchListScreen(),
    RestaurantListScreen(),
    HungerListScreen(),
    UserDetailsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    print('firebaseMessaging.configure');
    globals.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        int lunchId = message['data']['id'];
        print('LunchId = '+lunchId.toString());
        await lunchDeetails(lunchId).then((value) {
          print('Lunch user = '+value.username);
          if (value.username != globals.sessionUser) {
            globals.lunchSelected = value;
            print('push');
            Navigator.push(
              navigatorKey.currentContext,
              MaterialPageRoute(
                builder: (_) => LunchDetailsScreen(),
              ),
            );
          }
        });
        /*
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body'] + ' (' + message['data']['id'] + ')'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        */
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    if (globals.notificationLunch) {
      print('Subscribe');
      globals.firebaseMessaging.subscribeToTopic('lunch');
    }
    else {
      print('Unsubscribe');
      globals.firebaseMessaging.unsubscribeFromTopic('lunch');
    }
  }


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: navigatorKey,
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Lunches')),
          new BottomNavigationBarItem(icon: Icon(Icons.restaurant), title: Text('Restaurants')),
          //new BottomNavigationBarItem(icon: Icon(Icons.attach_money),   title: Text('Settlement')),
          new BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('Users')),
          new BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}

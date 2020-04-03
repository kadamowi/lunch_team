import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';
import 'package:lunch_team/screens/LunchListScreen.dart';
import 'package:lunch_team/screens/RestaurantListScreen.dart';
import 'package:lunch_team/screens/UserDetailsScreen.dart';
import 'package:lunch_team/model/globals.dart' as globals;

//Klucz API AIzaSyBPF6Qf-h28b56r3Ac_VVs5egeG0csI39I

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LunchListScreen(),
    RestaurantListScreen(),
    HungerListScreen(),
    UserDetailsScreen(),
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        AlertDialog(
          content: Text("Message from firebase:"),
          actions: <Widget>[
            FlatButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        //_homeScreenText = "Push Messaging token: $token";
        globals.token = token;
      });
      print('FCM Token:'+token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),  title: Text('Lunches')),
          new BottomNavigationBarItem(icon: Icon(Icons.restaurant),     title: Text('Restaurants')),
          //new BottomNavigationBarItem(icon: Icon(Icons.attach_money),   title: Text('Settlement')),
          new BottomNavigationBarItem(icon: Icon(Icons.people),         title: Text('Users')),
          new BottomNavigationBarItem(icon: Icon(Icons.person),         title: Text('Profile'))
        ],
      ),
    );
  }
}
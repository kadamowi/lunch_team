import 'package:flutter/material.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';
import 'package:lunch_team/screens/LunchListScreen.dart';
import 'package:lunch_team/screens/RestaurantListScreen.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    RestaurantListScreen(),
    LunchListScreen(),
    HungerListScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            title: Text('Restaurants'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            title: Text('Lunches'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Users')
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lunch_team/screens/HomeScreen.dart';
import 'package:lunch_team/screens/HungerListScreen.dart';
import 'package:lunch_team/screens/LunchListScreen.dart';
import 'package:lunch_team/screens/RestaurantListScreen.dart';
import 'package:lunch_team/screens/UserDetailsScreen.dart';

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
    HomeScreen(),
    HungerListScreen(),
    UserDetailsScreen(),
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
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),  title: Text('Lunches')),
          new BottomNavigationBarItem(icon: Icon(Icons.restaurant),     title: Text('Restaurants')),
          new BottomNavigationBarItem(icon: Icon(Icons.attach_money),   title: Text('Settlement')),
          new BottomNavigationBarItem(icon: Icon(Icons.people),         title: Text('Users')),
          new BottomNavigationBarItem(icon: Icon(Icons.person),         title: Text('Profile'))
        ],
      ),
    );
  }
}
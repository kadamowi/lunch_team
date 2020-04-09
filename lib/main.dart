import 'package:flutter/material.dart';
import 'package:lunch_team/screens/LoginScreen.dart';
import 'screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lunch Team',
      theme: ThemeData(
        scaffoldBackgroundColor:Colors.grey[200],
        primaryColor: Colors.orange[800],
        accentColor: Colors.orange[800],
      ),
      home: SplashScreen(),
    );
  }
}
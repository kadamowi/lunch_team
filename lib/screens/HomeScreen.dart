import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch Team'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child:RaisedButton(
              color: Colors.white,
              textColor: Colors.lightGreen,
              child: Text("New Lunch"),
              onPressed: (){
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
            ),
          ),
          Center(child: Container()),
          Center(child: Container())
        ],
      ),
    );
  }
}
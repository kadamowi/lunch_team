library lunch_team.globals;

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/Meal.dart';
import 'package:lunch_team/model/User.dart';



bool isLogged = false;
PackageInfo versionInfo;
String errorMessage = 'OK';

String sessionId;
String sessionUser;
Restaurant restaurantSelected;
Lunch lunchSelected;
Meal mealSelected;
User userLogged;

Map restaurantSets;

final Map<String, String> statusDesc = {
  'COLLECTING': 'Collecting',
  'DELIVERING': 'Delivering',
  'TO_SETTLEMENT': 'To settlement',
  'SETTLEMENTED': 'Settlemented',
};

final Map statusColors = {
  'COLLECTING': Colors.orange,
  'DELIVERING': Colors.blue,
  'TO_SETTLEMENT': Colors.red,
  'SETTLEMENTED': Colors.green,
};

DateTime dateFrom = DateTime.now().add(Duration(days: -5));
DateTime dateTo = DateTime.now().add(Duration(days: 2));

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
String token = 'token';
bool notificationLunch = false;
bool notificationSettlement = false;
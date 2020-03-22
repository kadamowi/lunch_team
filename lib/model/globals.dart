library lunch_team.globals;

import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/Meal.dart';

bool isLogged = false;
String errorMessage = 'OK';

SessionLunch sessionLunch;
Restaurant restaurantSelected;
Lunch lunchSelected;
Meal mealSelected;

Map restaurantSets;

DateTime dateFrom = DateTime.now().add(Duration(days: -3));
DateTime dateTo = DateTime.now();
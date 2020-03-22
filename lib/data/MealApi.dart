import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Meal.dart';
import 'package:lunch_team/model/MealRequest.dart';


Future<List<Meal>> fetchMealList(int lunchId) async {
  // prepare JSON for request
  String reqJson = json.encode(MealListRequest(
      request: 'meal.list',
      session: globals.sessionLunch.sessionId,
      arguments: MealListArguments(
        lunchId: lunchId,
      )
  ));
  // make POST request
  //print('fetch meal.list ...');
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var resp = result['response'];
  var m = resp['meals'];
  //print(m.toString());
  var meals = m.map((i) => Meal.fromJson(i)).toList();
  List<Meal> mealList = new List<Meal>();
  for (Meal meal in meals) {
    mealList.add(meal);
  }
  return mealList;
}

Future<String> setSettled(int mealId) async {
  // prepare JSON for request
  String reqJson = json.encode(MealSettledRequest(
      request: 'meal.settled',
      session: globals.sessionLunch.sessionId,
      arguments: MealSettledArguments(
        mealId: mealId,
      )
  ));
  // make POST request
  //print('Set settlement:'+reqJson);
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  //print('Result:'+result.toString());
  var resp = result['response'];
  if (resp != null) {
    //print('resp:'+resp.toString());
    var settledMeal = resp['settledMeal'];
    if (!settledMeal)
      return 'Settlement problem';
  } else {
    //print('Technical problem');
    return 'Technical problem';
  }
  return null;
}
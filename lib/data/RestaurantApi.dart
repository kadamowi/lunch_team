import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/model/RestaurantRequest.dart';

Future<Restaurant> detailsRestaurant(restaurantId) async {
  //print('detailsRestaurant for '+restaurantId.toString());
  // prepare JSON for request
  String reqJson = json.encode(RestaurantDetailsRequest(
      request: 'restaurant.details',
      session: globals.sessionLunch.sessionId,
      arguments: RestaurantDetailsArguments(
        restaurantId: restaurantId,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:'+response.statusCode.toString());
  var result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var res = result['response'];
    if (res != null) {
      //print(res);
      var restaurant = Restaurant.fromJson(res);
      return restaurant;
    } else {
      print('No response');
    }
  } else {
    //print('statusCode:' + response.statusCode.toString());
    var res = result['error'];
    if (res != null) {
      print('error:' + res.toString());
    } else {
      print('Bad request');
    }
  }
}

Future<List<Restaurant>> restaurantList() async {
  // prepare JSON for request
  String reqJson = json.encode(RestaurantListRequest(
      request: 'restaurant.list',
      session: globals.sessionLunch.sessionId));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var resp = result['response'];
  var u = resp['restaurants'];
  //print(u.toString());
  var restaurants = u.map((i) => Restaurant.fromJson(i)).toList();
  List<Restaurant> restaurantList = new List<Restaurant>();
  for (Restaurant restaurant in restaurants) {
    //print(user.username);
    restaurantList.add(restaurant);
  }
  return restaurantList;
}


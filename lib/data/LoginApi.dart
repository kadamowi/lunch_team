import 'package:http/http.dart';
import 'package:lunch_team/data/UserApi.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/request/LoginRequest.dart';
import 'package:lunch_team/model/Restaurant.dart';
import 'package:lunch_team/data/RestaurantApi.dart';
import 'package:lunch_team/model/globals.dart' as globals;

Future<String> getSavedUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globals.versionInfo = await PackageInfo.fromPlatform();
  globals.sessionUser = prefs.getString('username') ?? '';
  globals.sessionId = prefs.getString('session') ?? '';

  return 'OK';
}

Future<String> loginApp(String username, String password) async {
  // prepare JSON for request
  String reqJson = json.encode(LoginRequest(
      request: 'user.login',
      arguments: LoginUser(
        username: username,
        password: password,
      )));
  //print('userLogin req:'+reqJson.toString());
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool userLogin = responseTag['userLogin'];
      if (userLogin) {
        String sessionId = responseTag['session'];
        globals.sessionUser = username;
        globals.sessionId = sessionId;
        int userId = responseTag['userId'];
        // Pobranie aktualnych danych usera
        if (userId != null && userId > 0) {
          globals.userLogged = await detailsUser(userId);
          print(globals.userLogged.displayName + ' is logged (' + globals.userLogged.userId.toString() + ')');
          print('email:' + globals.userLogged.email);
        } else {
          return 'No userId:' + responseTag.toString();
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('session', sessionId);
        // Pobranie listy restauracji
        List<Restaurant> restaurants = await restaurantList();
        globals.restaurantSets = new Map();
        for (Restaurant r in restaurants) {
          globals.restaurantSets[r.restaurantId] = r.restaurantName;
        }
        String value = await userSettingGet('notification', 'lunch');
        globals.notyfiLunch = (value == '1');
        value = await userSettingGet('notification', 'settlement');
        globals.notyfiSettlement = (value == '1');
      } else {
        return 'Not logged: ' + responseTag.toString();
      }
    } else {
      return 'No response: ' + result.toString();
    }
  } else {
    if (response.statusCode == 400)
      return 'Bad credentials';
    else {
      return 'Technical error: ' + response.statusCode.toString();
    }
  }
  return null;
}

Future<String> logoutApp() async {
  // prepare JSON for request
  String reqJson = json.encode(LogoutRequest(
    request: 'user.logout',
    session: globals.sessionId,
  ));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var res = result['response'];
  if (res != null) {
    bool logout = res['logout'];
    if (!logout) return 'Not logout';
  } else {
    return result.toString();
  }
  return null;
}

Future<String> createAccount(LoginUser loginUser) async {
  // prepare JSON for request
  String reqJson = json.encode(LoginRequest(request: 'user.register', arguments: loginUser));
  // make POST request
  print(reqJson);
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var resp = result['response'];
  print(resp);
  if (resp != null) {
    bool registerUser = resp['registerUser'];
    print('registerUser:' + registerUser.toString());
    if (!registerUser) {
      globals.errorMessage = 'User "' + loginUser.username + '" not registered';
      return globals.errorMessage;
    }
  } else {
    resp = result['error'];
    if (resp != null)
      globals.errorMessage = 'Register error ' + resp.toString();
    else
      globals.errorMessage = 'Register error ' + result.toString();
    return globals.errorMessage;
  }
  return null;
}

Future<bool> userSessionValidate() async {
  // prepare JSON for request
  String reqJson = json.encode(SessionValidateRequest(
      request: 'user.session.validate',
      session: globals.sessionId
  ));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool sessionValidate = responseTag['sessionValidate'];
      if (sessionValidate) {
        globals.userLogged = await detailsUser(0);
        print(globals.userLogged.displayName + ' is logged (' + globals.userLogged.userId.toString() + ')');
        print('email:' + globals.userLogged.email);
        // Pobranie listy restauracji
        List<Restaurant> restaurants = await restaurantList();
        globals.restaurantSets = new Map();
        for (Restaurant r in restaurants) {
          globals.restaurantSets[r.restaurantId] = r.restaurantName;
        }
        String value = await userSettingGet('notification', 'lunch');
        globals.notyfiLunch = (value == '1');
        value = await userSettingGet('notification', 'settlement');
        globals.notyfiSettlement = (value == '1');
      }
      return sessionValidate;
    } else
      return false;
  } else
    return false;
}

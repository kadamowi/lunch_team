import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/LoginRequest.dart';
import 'package:lunch_team/model/globals.dart' as globals;

Future<LoginUser> getSavedUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return new LoginUser(
      username: (prefs.getString('username') ?? ''),
      password: (prefs.getString('password') ?? ''));
}

Future<String> loginApp(String username, String password) async {
  // prepare JSON for request
  String reqJson = json.encode(LoginRequest(
      request: 'user.login',
      arguments: LoginUser(
        username: username,
        password: password,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var res = result['response'];
  if (res != null) {
    print(username + ' entered');
    String sessionId = res['session'];
    if (sessionId != null && sessionId != 'null') return sessionId;
  }
  return null;
}

Future<String>  createAccount(LoginUser loginUser) async {
  // prepare JSON for request
  String reqJson =
      json.encode(LoginRequest(request: 'user.register', arguments: loginUser));
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

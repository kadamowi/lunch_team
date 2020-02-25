import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/LoginRequest.dart';

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

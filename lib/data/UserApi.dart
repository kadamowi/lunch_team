import 'package:http/http.dart';
import 'dart:convert';
import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/User.dart';
import 'package:lunch_team/request/UserRequest.dart';
import 'package:lunch_team/request/TeamUsersRequest.dart';

Future<List<User>> userList() async {
  // prepare JSON for request
  String reqJson = json.encode(TeamUsersRequest(
      request: 'user.list', session: globals.sessionLunch.sessionId));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  var result = jsonDecode(response.body);
  var resp = result['response'];
  var u = resp['users'];
  //print(u.toString());
  var users = u.map((i) => User.fromJson(i)).toList();
  List<User> userList = new List<User>();
  for (User user in users) {
    //print(user.username);
    userList.add(user);
  }
  return userList;
}

Future<User> detailsUser(userId) async {
  // prepare JSON for request
  String reqJson = json.encode(UserDetailsRequest(
      request: 'user.details',
      session: globals.sessionLunch.sessionId,
      arguments: UserDetailsArguments(
        userId: userId,
      )));
  // make POST request
  //print('detailsUser request:'+reqJson);
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('detailsUser statusCode:'+response.statusCode.toString());
  var result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var res = result['response'];
    if (res != null) {
      //print('detailsUser:'+res.toString());
      var user = User.fromJson(res);
      return user;
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

Future<String> editUser() async {
  // prepare JSON for request
  String reqJson = json.encode(UserEditRequest(
      request: 'user.edit',
      session: globals.sessionLunch.sessionId,
      arguments: UserEditArguments(
        displayName: globals.userLogged.displayName,
        email: globals.userLogged.email,
        avatarUrl: globals.userLogged.avatarUrl
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:'+response.statusCode.toString());
  var result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var res = result['response'];
    if (res != null) {
      //print('detailsUser:'+res.toString());
      bool editUser = res['editUser'];
      if (editUser) {
        globals.userLogged = await detailsUser(globals.userLogged.userId);
        return null;
      }
      else
        return 'Not edited';
    } else {
      return 'No response';
    }
  } else {
    var res = result['error'];
    if (res != null) {
      return 'error:' + res.toString();
    } else {
      return 'Bad request';
    }
  }
}

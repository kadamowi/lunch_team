import 'package:http/http.dart';
import 'dart:convert';
import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/User.dart';
import 'package:lunch_team/request/UserRequest.dart';
import 'package:lunch_team/request/TeamUsersRequest.dart';

Future<List<User>> userList() async {
  // prepare JSON for request
  String reqJson = json.encode(TeamUsersRequest(request: 'user.list', session: globals.sessionId));
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
  String reqJson;
  if (userId == 0)
    reqJson = json.encode(UserDetailsRequest(
      request: 'user.details',
      session: globals.sessionId,
    ));
  else
    reqJson = json.encode(UserDetailsRequest(
        request: 'user.details',
        session: globals.sessionId,
        arguments: UserDetailsArguments(
          userId: userId,
        )));
  // make POST request
  //print('detailsUser request:' + reqJson);
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('detailsUser statusCode:' + response.statusCode.toString());
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
  return null;
}

Future<String> editUser() async {
  // prepare JSON for request
  String reqJson = json.encode(UserEditRequest(
      request: 'user.edit',
      session: globals.sessionId,
      arguments: UserEditArguments(displayName: globals.userLogged.displayName, email: globals.userLogged.email, avatarUrl: globals.userLogged.avatarUrl)));
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
      } else
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

Future<String> passwordUser(String oldP, String newP) async {
  // prepare JSON for request
  String reqJson = json.encode(UserPasswordRequest(
      request: 'user.changePassword',
      session: globals.sessionId,
      arguments: UserPasswordArguments(
        oldPassword: oldP,
        newPassword: newP,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:'+response.statusCode.toString());
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      //print('detailsUser:'+res.toString());
      bool changePass = responseTag['changePassword'];
      if (!changePass) {
        return 'Password not changed:' + responseTag.toString();
      }
    } else {
      return 'No response: ' + result.toString();
    }
  } else {
    return 'Technical error: ' + response.statusCode.toString();
  }
  return null;
}

Future<String> userSettingSet(String namespace, String name, String value) async {
  // prepare JSON for request
  String reqJson = json.encode(UserSettingSetRequest(
      request: 'user.setting.set',
      session: globals.sessionId,
      arguments: UserSettingSetArguments(
        namespace: namespace,
        name: name,
        value: value
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:'+response.statusCode.toString());
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool settingSet = responseTag['settingSet'];
      if (!settingSet) {
        return 'Setting not saved:' + responseTag.toString();
      }
    } else {
      return 'No response: ' + result.toString();
    }
  } else {
    return 'Technical error: ' + response.statusCode.toString();
  }
  return null;
}

Future<String> userSettingGet(String namespace, String name) async {
  // prepare JSON for request
  String reqJson = json.encode(UserSettingGetRequest(
      request: 'user.setting.get',
      session: globals.sessionId,
      arguments: UserSettingGetArguments(
          namespace: namespace,
          name: name,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:'+response.statusCode.toString());
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      String value = responseTag['value'];
      if (value == null) {
        return 'Setting not saved:' + responseTag.toString();
      } else
        return value;
    } else {
      return 'No response: ' + result.toString();
    }
  } else {
    return 'Technical error: ' + response.statusCode.toString();
  }
}

Future<String> userUploadAvatar(String avatar) async {
  // prepare JSON for request
  String reqJson = json.encode(UserEditUploadAvatarRequest(
      request: 'user.edit.uploadAvatar',
      session: globals.sessionId,
      arguments: UserEditUploadAvatarArguments(
        avatarData: avatar,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  print('statusCode:'+response.statusCode.toString());
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print(result.toString());
    var responseTag = result['response'];
    if (responseTag != null) {
      bool avatarUploaded  = responseTag['avatarUploaded'];
      if (avatarUploaded) {
        globals.userLogged.avatarUrl = responseTag['avatarURL'];
      } else {
        return 'Image not uploaded:' + responseTag.toString();
      }
    } else {
      return 'No response: ' + result.toString();
    }
  } else {
    print('Technical error: ' + response.statusCode.toString());
    return 'Technical error: ' + response.statusCode.toString();
  }
  return null;
}

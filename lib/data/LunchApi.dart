import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/request/LunchRequest.dart';
import 'package:lunch_team/data/NotifyApi.dart';

Future<String> createLunch(Lunch lunch) async {
  // prepare JSON for request
  String reqJson = json.encode(LunchCreateRequest(
      request: 'lunch.create',
      session: globals.sessionId,
      arguments: LunchCreateArguments(
        restaurantId: lunch.restaurantId,
        lunchType: lunch.lunchType,
        lunchDescription: lunch.lunchDescription,
        transportCost: (lunch.transportCost ?? '0.00').toString(),
        orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
        lunchTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
      )));
  //print('createLunch:'+reqJson);
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool createLunch = responseTag['createLunch'];
      if (!createLunch) {
        return 'Creating lunch impossible';
      }
    } else
      return 'Technical error: (no response)';
  } else {
    //print(response.body);
    return 'Technical error: ' + response.statusCode.toString();
  }
  await sendNotification(
      lunch.username,
      lunch.lunchDescription,
      '/topics/lunch',
      lunch.lunchId.toString());
  return null;
}

Future<String> editLunch(Lunch lunch) async {
  // prepare JSON for request
  String reqJson = json.encode(LunchEditRequest(
      request: 'lunch.edit',
      session: globals.sessionId,
      arguments: LunchEditArguments(
        lunchId: lunch.lunchId,
        restaurantId: lunch.restaurantId,
        lunchDescription: lunch.lunchDescription,
        lunchType: lunch.lunchType ?? 0,
        transportCost: (lunch.transportCost ?? '0.00').toString(),
        orderTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchOrderTime),
        lunchTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(lunch.lunchLunchTime),
      )));
  //print('editLunch:'+reqJson);
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool editLunch = responseTag['editLunch'];
      if (!editLunch) {
        return 'Edit impossible';
      }
    } else
      return 'Technical error: (no response)';
  } else {
    //print(response.body);
    return 'Technical error: ' + response.statusCode.toString();
  }
  await sendNotification(
      lunch.username,
      lunch.lunchDescription,
      '/topics/lunch',
      lunch.lunchId.toString());
  return null;
}

Future<String> deleteLunch(int lunchId) async {
  // prepare JSON for request
  String reqJson = json.encode(LunchDeleteRequest(
      request: 'lunch.delete',
      session: globals.sessionId,
      arguments: LunchDeleteArguments(
        lunchId: lunchId,
      )));
  //print('deleteLunch:'+reqJson);
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var responseTag = result['response'];
    if (responseTag != null) {
      bool deleteLunch = responseTag['deleteLunch'];
      if (!deleteLunch) {
        return 'Delete impossible';
      }
    } else
      return 'Technical error: (no response)';
  } else
    return 'Technical error: ' + response.statusCode.toString();
  return null;
}

Future<Lunch> lunchDeetails(lunchId) async {
  //print('detailsLunch for ' + lunchId.toString());
  // prepare JSON for request
  String reqJson = json.encode(LunchDetailsRequest(
      request: 'lunch.details',
      session: globals.sessionId,
      arguments: LunchDetailsArguments(
        lunchId: lunchId,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  //print('statusCode:' + response.statusCode.toString());
  var result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var res = result['response'];
    if (res != null) {
      //print(res);
      var lunch = Lunch.fromJson(res);
      return lunch;
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

Future<List<Lunch>> lunchList(DateTime dateFrom, DateTime dateTo,
    bool onlyMyMeal, bool onlyMyLunch) async {
  globals.errorMessage = '';
  // prepare JSON for request
  String reqJson = json.encode(LunchListRequest(
      request: 'lunch.list',
      session: globals.sessionId,
      filters: LunchListFilters(
          dateFrom: DateFormat('yyyy-MM-dd').format(dateFrom),
          dateTo: DateFormat('yyyy-MM-dd').format(dateTo),
          onlyMyMeal: onlyMyMeal,
          onlyMyLunch: onlyMyLunch)));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  List<Lunch> lunchList = new List<Lunch>();
  var result = jsonDecode(response.body);
  var resp = result['response'];
  if (resp == null) {
    globals.errorMessage = 'Technical problem';
  } else {
    var l = resp['lunches'];
    if (l == null) {
      globals.errorMessage = resp.toString();
    } else {
      var lunches = l.map((i) => Lunch.fromJson(i)).toList();
      for (Lunch lunch in lunches) {
        lunchList.add(lunch);
      }
    }
  }
  return lunchList;
}

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/request/LunchRequest.dart';

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

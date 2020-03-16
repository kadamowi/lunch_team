import 'package:http/http.dart';
import 'dart:convert';

import 'package:lunch_team/model/globals.dart' as globals;
import 'package:lunch_team/model/LunchTeamCommon.dart';
import 'package:lunch_team/model/Lunch.dart';
import 'package:lunch_team/model/LunchRequest.dart';

Future<Lunch> detailsLunch(lunchId) async {
  print('detailsLunch for '+lunchId.toString());
  // prepare JSON for request
  String reqJson = json.encode(LunchDetailsRequest(
      request: 'lunch.details',
      session: globals.sessionLunch.sessionId,
      arguments: LunchDetailsArguments(
        lunchId: lunchId,
      )));
  // make POST request
  Response response = await post(urlApi, headers: headers, body: reqJson);
  print('statusCode:'+response.statusCode.toString());
  var result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var res = result['response'];
    if (res != null) {
      print(res);
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
}

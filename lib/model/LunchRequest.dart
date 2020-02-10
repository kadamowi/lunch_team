import 'package:lunch_team/model/Lunch.dart';

class LunchCreateArguments {
  int restaurantId;
  String username;
  bool lunchType;
  String lunchDescription;
  double transportCost;
  DateTime orderTime;
  DateTime lunchTime;

  LunchCreateArguments({
    this.restaurantId,
    this.username,
    this.lunchType,
    this.lunchDescription,
    this.transportCost,
    this.orderTime,
    this.lunchTime});

  toJson() {
    return {
      'restaurantId': restaurantId,
      'username': username,
      'lunchType': lunchType,
      'lunchDescription': lunchDescription,
      'transportCost': transportCost,
      'orderTime': orderTime,
      'lunchTime': lunchTime,
    };
  }
}

class LunchCreateRequest{
  String request;
  String session;
  LunchCreateArguments arguments;

  LunchCreateRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class LunchEditRequest {
  String request;
  String session;
  Lunch arguments;

  LunchEditRequest({this.request,this.session,this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class LunchDeleteArguments {
  int lunchId;

  LunchDeleteArguments({this.lunchId});

  toJson() {
    return {
      'lunchId': lunchId,
    };
  }
}

class LunchDeleteRequest {
  String request;
  String session;
  LunchDeleteArguments arguments;

  LunchDeleteRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class LunchListRequest {
  String request;
  String session;

  LunchListRequest({this.request,this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}

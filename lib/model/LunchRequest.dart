import 'package:lunch_team/model/Lunch.dart';

class LunchCreateArguments {
  int restaurantId;
  String lunchDescription;
  int lunchType;
  String transportCost;
  String orderTime;
  String lunchTime;

  LunchCreateArguments(
      {this.restaurantId,
      this.lunchDescription,
      this.lunchType,
      this.transportCost,
      this.orderTime,
      this.lunchTime});

  toJson() {
    return {
      'restaurantId': restaurantId,
      'lunchDescription': lunchDescription,
      'lunchType': lunchType,
      'transportCost': transportCost,
      'orderTime': orderTime,
      'lunchTime': lunchTime,
    };
  }
}

class LunchCreateRequest {
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

  LunchEditRequest({this.request, this.session, this.arguments});

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

  LunchListRequest({this.request, this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}

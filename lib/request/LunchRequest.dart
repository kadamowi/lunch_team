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

class LunchEditArguments {
  int lunchId;
  int restaurantId;
  String lunchDescription;
  int lunchType;
  String transportCost;
  String orderTime;
  String lunchTime;

  LunchEditArguments(
      {this.lunchId,
      this.restaurantId,
      this.lunchDescription,
      this.lunchType,
      this.transportCost,
      this.orderTime,
      this.lunchTime});

  toJson() {
    return {
      'lunchId': lunchId,
      'restaurantId': restaurantId,
      'lunchDescription': lunchDescription,
      'lunchType': lunchType,
      'transportCost': transportCost,
      'orderTime': orderTime,
      'lunchTime': lunchTime,
    };
  }
}

class LunchEditRequest {
  String request;
  String session;
  LunchEditArguments arguments;

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

class LunchListFilters {
  String dateFrom;
  String dateTo;
  bool onlyMyMeal;
  bool onlyMyLunch;

  LunchListFilters(
      {this.dateFrom, this.dateTo, this.onlyMyMeal, this.onlyMyLunch});

  toJson() {
    return {
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'onlyMyMeal': onlyMyMeal,
      'onlyMyLunch': onlyMyLunch,
    };
  }
}

class LunchListRequest {
  String request;
  String session;
  LunchListFilters filters;

  LunchListRequest({this.request, this.session, this.filters});

  toJson() {
    return {
      'request': request,
      'session': session,
      'filters': filters,
    };
  }
}

class LunchDetailsArguments {
  int lunchId;

  LunchDetailsArguments({this.lunchId});

  toJson() {
    return {
      'lunchId': lunchId,
    };
  }
}

class LunchDetailsRequest {
  String request;
  String session;
  LunchDetailsArguments arguments;

  LunchDetailsRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

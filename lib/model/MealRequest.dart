import 'package:lunch_team/model/Meal.dart';

class MealCreateArguments {
  int lunchId;
  String mealDescription;
  String mealCost;

  MealCreateArguments({this.lunchId, this.mealDescription, this.mealCost});

  toJson() {
    return {
      'lunchId': lunchId,
      'mealName': mealDescription,
      'mealCost': mealCost,
    };
  }
}

class MealCreateRequest {
  String request;
  String session;
  MealCreateArguments arguments;

  MealCreateRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class MealEditRequest {
  String request;
  String session;
  Meal arguments;

  MealEditRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class MealDeleteArguments {
  int mealId;

  MealDeleteArguments({this.mealId});

  toJson() {
    return {
      'mealId': mealId,
    };
  }
}

class MealDeleteRequest {
  String request;
  String session;
  MealDeleteArguments arguments;

  MealDeleteRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class MealListArguments {
  int lunchId;

  MealListArguments({this.lunchId});

  toJson() {
    return {
      'lunchId': lunchId,
    };
  }
}

class MealListRequest {
  String request;
  String session;
  MealListArguments arguments;

  MealListRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

import 'package:lunch_team/model/Restaurant.dart';

class RestaurantCreateArguments {
  String restaurantName;
  String restaurantDescription;
  String restaurantUrl;
  String restaurantUrlLogo;

  RestaurantCreateArguments(
      {this.restaurantName,
      this.restaurantDescription,
      this.restaurantUrl,
      this.restaurantUrlLogo});

  toJson() {
    return {
      'restaurantName': restaurantName,
      'restaurantDescription': restaurantDescription,
      'restaurantUrl': restaurantUrl,
      'restaurantUrlLogo': restaurantUrlLogo,
    };
  }
}

class RestaurantCreateRequest {
  String request;
  String session;
  RestaurantCreateArguments arguments;

  RestaurantCreateRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class RestaurantEditRequest {
  String request;
  String session;
  Restaurant arguments;

  RestaurantEditRequest({this.request,this.session,this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class RestaurantDeleteArguments {
  int restaurantId;

  RestaurantDeleteArguments({this.restaurantId});

  toJson() {
    return {
      'restaurantId': restaurantId,
    };
  }
}

class RestaurantDeleteRequest {
  String request;
  String session;
  RestaurantDeleteArguments arguments;

  RestaurantDeleteRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class RestaurantListRequest {
  String request;
  String session;

  RestaurantListRequest({this.request,this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}

class RestaurantDetailsArguments {
  int restaurantId;

  RestaurantDetailsArguments({this.restaurantId});

  toJson() {
    return {
      'restaurantId': restaurantId,
    };
  }
}

class RestaurantDetailsRequest {
  String request;
  String session;
  RestaurantDetailsArguments arguments;

  RestaurantDetailsRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

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

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
class Restaurant {
  String restaurantId;
  String restaurantName;
  String restaurantUrl;

  Restaurant({this.restaurantId, this.restaurantName, this.restaurantUrl});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
      restaurantId: parsedJson['restaurantId'],
      restaurantName: parsedJson['restaurantName'],
      restaurantUrl: parsedJson['restaurantUrl'],
    );
  }
}

class Restaurant {
  String restaurantId;
  String restaurantName;
  String restaurantDescription;
  String restaurantUrl;
  String restaurantUrlLogo;

  Restaurant({
    this.restaurantId,
    this.restaurantName,
    this.restaurantDescription,
    this.restaurantUrl,
    this.restaurantUrlLogo,
  });

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
      restaurantId: parsedJson['restaurantId'],
      restaurantName: parsedJson['restaurantName'],
      restaurantDescription: parsedJson['restaurantDescription'],
      restaurantUrl: parsedJson['restaurantUrl'],
      restaurantUrlLogo: parsedJson['restaurantUrlLogo']
    );
  }
}

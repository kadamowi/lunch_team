class Lunch {
  int lunchId;
  int restaurantId;
  String username;
  bool lunchType;
  String lunchDescription;
  double transportCost;
  DateTime orderTime;
  DateTime lunchTime;
  int totalMeal;
  double totalMealCost;

  Lunch({
    this.lunchId,
    this.restaurantId,
    this.username,
    this.lunchType,
    this.lunchDescription,
    this.transportCost,
    this.orderTime,
    this.lunchTime,
    this.totalMeal,
    this.totalMealCost,
  });

  factory Lunch.fromJson(Map<String, dynamic> parsedJson) {
    return Lunch(
      lunchId: parsedJson['lunchId'],
      restaurantId: parsedJson['restaurantId'],
      username: parsedJson['username'],
      lunchType: parsedJson['lunchType'],
      lunchDescription: parsedJson['lunchDescription'],
      transportCost: parsedJson['transportCost'],
      orderTime: parsedJson['orderTime'],
      lunchTime: parsedJson['lunchTime'],
      totalMeal: parsedJson['totalMeal'],
      totalMealCost: parsedJson['totalMealCost'],
    );
  }
}

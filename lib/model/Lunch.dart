class Lunch {
  int lunchId;
  int restaurantId;
  String restaurantName;
  int userId;
  String username;
  int lunchType;
  String lunchDescription;
  double transportCost;
  DateTime lunchOrderTime;
  DateTime lunchLunchTime;
  int mealCount;
  //double totalMealCost;

  Lunch({
    this.lunchId,
    this.restaurantId,
    this.restaurantName,
    this.userId,
    this.username,
    this.lunchType,
    this.lunchDescription,
    this.transportCost,
    this.lunchOrderTime,
    this.lunchLunchTime,
    this.mealCount,
    //this.totalMealCost,
  });

  factory Lunch.fromJson(Map<String, dynamic> parsedJson) {
    return Lunch(
      lunchId: parsedJson['lunchId'],
      restaurantId: parsedJson['restaurantId'],
      restaurantName: parsedJson['restaurantName'],
      userId: parsedJson['userId'],
      username: parsedJson['userName'],
      //lunchType: parsedJson['lunchType'],
      lunchDescription: parsedJson['lunchDescription'],
      //transportCost: parsedJson['transportCost'],
      lunchOrderTime: DateTime.parse(parsedJson['lunchOrderTime']),
      lunchLunchTime: DateTime.parse(parsedJson['lunchLunchTime']),
      mealCount: parsedJson['mealCount'],
      //totalMealCost: parsedJson['totalMealCost'],
    );
  }
}

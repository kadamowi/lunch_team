class Meal {
  int mealId;
  int lunchId;
  int userId;
  String username;
  String mealName;
  double mealCost;
  double finalCost;

  Meal({
    this.mealId,
    this.lunchId,
    this.userId,
    this.username,
    this.mealName,
    this.mealCost,
    this.finalCost,
  });

  factory Meal.fromJson(Map<String, dynamic> parsedJson) {
    return Meal(
      mealId: parsedJson['mealId'],
      //lunchId: parsedJson['lunchId'],
      userId: parsedJson['userId'],
      username: parsedJson['username'],
      mealName: parsedJson['mealName'],
      mealCost: double.parse(parsedJson['expectedCost']),
      //finalCost: double.parse(parsedJson['finalCost']),
    );
  }
}

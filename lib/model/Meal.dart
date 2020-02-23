class Meal {
  int mealId;
  int lunchId;
  int userId;
  String username;
  String mealDescription;
  double mealCost;
  double totalCost;

  Meal({
    this.mealId,
    this.lunchId,
    this.userId,
    this.username,
    this.mealDescription,
    this.mealCost,
    this.totalCost,
  });

  factory Meal.fromJson(Map<String, dynamic> parsedJson) {
    return Meal(
      mealId: parsedJson['mealId'],
      lunchId: parsedJson['lunchId'],
      userId: parsedJson['userId'],
      username: parsedJson['username'],
      mealDescription: parsedJson['mealDescription'],
      mealCost: parsedJson['mealCost'],
      totalCost: parsedJson['totalCost'],
    );
  }
}

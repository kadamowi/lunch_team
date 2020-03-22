class Lunch {
  int lunchId;
  int restaurantId;
  String restaurantName;
  String restaurantLogo;
  String restaurantUrl;
  int userId;
  String username;
  int lunchType;
  String lunchDescription;
  double transportCost;
  DateTime lunchOrderTime;
  DateTime lunchLunchTime;
  int mealCount;
  double lunchCost;
  String status;
  //double totalMealCost;

  Lunch({
    this.lunchId,
    this.restaurantId,
    this.restaurantName,
    this.restaurantLogo,
    this.restaurantUrl,
    this.userId,
    this.username,
    this.lunchType,
    this.lunchDescription,
    this.transportCost,
    this.lunchOrderTime,
    this.lunchLunchTime,
    this.mealCount,
    this.lunchCost,
    this.status
    //this.totalMealCost,
  });

  factory Lunch.fromJson(Map<String, dynamic> parsedJson) {
    return Lunch(
      lunchId: parsedJson['lunchId'],
      restaurantId: parsedJson['restaurantId'],
      restaurantName: parsedJson['restaurantName'],
      restaurantLogo: parsedJson['restaurantUrlLogo'],
      restaurantUrl: parsedJson['restaurantUrl'],
      userId: parsedJson['userId'],
      username: parsedJson['userName'],
      lunchType: parsedJson['lunchType']??0,
      lunchDescription: parsedJson['lunchDescription'],
      transportCost: (parsedJson['transportCost']==null)?0:double.parse(parsedJson['transportCost']),
      lunchOrderTime: DateTime.parse(parsedJson['lunchOrderTime']),
      lunchLunchTime: DateTime.parse(parsedJson['lunchLunchTime']),
      mealCount: parsedJson['mealCount'],
      lunchCost: (parsedJson['lunchCost'].toString().length > 0)?double.parse(parsedJson['lunchCost']):0,
      status: parsedJson['status'],
      //totalMealCost: parsedJson['totalMealCost'],
    );
  }
}

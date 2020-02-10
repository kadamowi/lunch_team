class User {
  String userId;
  String username;

  User({this.userId, this.username});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      userId: parsedJson['userId'],
      username: parsedJson['username'],
    );
  }
}

class UsersList {
  final List<User> users;

  UsersList({this.users});

  factory UsersList.fromJson(List<dynamic> parsedJson) {
    List<User> users = new List<User>();

    return new UsersList(
      users: users,
    );
  }
}

//class Response {
//  List<User> users;
//}

//class TeamUserResponse {
//  Response response;
//}

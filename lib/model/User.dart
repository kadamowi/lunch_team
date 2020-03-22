class User {
  String userId;
  String username;
  String displayName;
  String avatarUrl;

  User({this.userId, this.username, this.displayName, this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      userId: parsedJson['userId'],
      username: parsedJson['username'],
      displayName: parsedJson['userDisplayName'],
      avatarUrl: parsedJson['userAvatarUrl']
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

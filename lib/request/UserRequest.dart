class UserEditArguments {
  String displayName;
  String email;
  String avatarUrl;

  UserEditArguments({this.displayName,this.email,this.avatarUrl});

  toJson() {
    return {
      'userDisplayName': displayName,
      'userEmail': email,
      'userAvatarUrl': avatarUrl,
    };
  }
}

class UserEditRequest {
  String request;
  String session;
  UserEditArguments arguments;

  UserEditRequest({this.request,this.session,this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class UserDetailsArguments {
  int userId;

  UserDetailsArguments({this.userId});

  toJson() {
    return {
      'userId': userId,
    };
  }
}

class UserDetailsRequest {
  String request;
  String session;
  UserDetailsArguments arguments;

  UserDetailsRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}
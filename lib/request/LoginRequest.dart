class LoginUser {
  String username;
  String password;

  LoginUser({this.username, this.password});

  toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginRequest {
  String request;
  LoginUser arguments;

  LoginRequest({this.request,this.arguments});

  toJson() {
    return {
      'request': request,
      'arguments': arguments,
    };
  }
}

class LogoutRequest {
  String request;
  String session;

  LogoutRequest({this.request,this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}

class SessionValidateRequest {
  String request;
  String session;

  SessionValidateRequest({this.request,this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}

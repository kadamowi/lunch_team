class LoginUser {
  String username;
  String password;
  String hardwareKey;

  LoginUser({this.username, this.password, this.hardwareKey});

  toJson() {
    return {
      'username': username,
      'password': password,
      'hardwareKey': hardwareKey
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

class RegisterUser {
  String username;
  String password;

  RegisterUser({this.username, this.password});

  toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class RegisterRequest {
  String request;
  RegisterUser arguments;

  RegisterRequest({this.request,this.arguments});

  toJson() {
    return {
      'request': request,
      'arguments': arguments,
    };
  }
}

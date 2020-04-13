class LoginUser {
  String username;
  String password;
  String email;
  String hardwareKey;

  LoginUser({this.username, this.password, this.email, this.hardwareKey});

  toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
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
  String email;

  RegisterUser({this.username, this.password, this.email});

  toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
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

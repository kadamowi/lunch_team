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

class UserPasswordArguments {
  String oldPassword;
  String newPassword;

  UserPasswordArguments({this.oldPassword,this.newPassword});

  toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}

class UserPasswordRequest {
  String request;
  String session;
  UserPasswordArguments arguments;

  UserPasswordRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class UserSettingSetArguments {
  String namespace;
  String name;
  String value;

  UserSettingSetArguments({this.namespace, this.name, this.value});

  toJson() {
    return {
      'namespace': namespace,
      'name': name,
      'value': value,
    };
  }
}

class UserSettingSetRequest {
  String request;
  String session;
  UserSettingSetArguments arguments;

  UserSettingSetRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class UserSettingGetArguments {
  String namespace;
  String name;

  UserSettingGetArguments({this.namespace, this.name});

  toJson() {
    return {
      'namespace': namespace,
      'name': name,
    };
  }
}

class UserSettingGetRequest {
  String request;
  String session;
  UserSettingGetArguments arguments;

  UserSettingGetRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}

class UserEditUploadAvatarArguments {
  String avatarData;

  UserEditUploadAvatarArguments({this.avatarData});

  toJson() {
    return {
      'avatarData': avatarData,
    };
  }
}

class UserEditUploadAvatarRequest {
  String request;
  String session;
  UserEditUploadAvatarArguments arguments;

  UserEditUploadAvatarRequest({this.request, this.session, this.arguments});

  toJson() {
    return {
      'request': request,
      'session': session,
      'arguments': arguments,
    };
  }
}


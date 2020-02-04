class TeamUsersRequest {
  String request;
  String session;

  TeamUsersRequest({this.request,this.session});

  toJson() {
    return {
      'request': request,
      'session': session,
    };
  }
}
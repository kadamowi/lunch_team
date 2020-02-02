final String urlApi = 'http://teamlunch.cybersoft.pl/api/v1/';
final Map<String, String> headers = {
  "Content-type": "application/json",
  "Accept": "application/json",
};

class SessionLunch {
  final String username;
  final String sessionId;

  SessionLunch(this.username,this.sessionId);
}
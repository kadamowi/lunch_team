import 'package:flutter/material.dart';
import 'package:lunch_team/model/globals.dart' as globals;

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.orange),
        strokeWidth: 10,
      ),
    );
  }
}

class MessageError extends StatelessWidget {
  const MessageError({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: message.length > 0,
      child: Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red,
            //fontSize: 18.0,
            //fontWeight:
            //FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class VersionText extends StatelessWidget {
  const VersionText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version '+ globals.versionInfo.version,
    );
  }
}


import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Text(
        message,
        style: TextStyle(
            color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

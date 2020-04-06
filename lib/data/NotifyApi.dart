import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:lunch_team/request/NotifyRequest.dart';

final String serverToken = 'AAAA5iE_Vu8:APA91bEyakz36eDrkR22SA9jC7y23mVgfWRzbTl430Jyg6ykMw63_biCTo4Xln_uGRheq7kDlPiL45jpoQfzwEpo1bpwBkXPaE3_9_iBzvqNFUV1ZCRuKmm4urDMMB1F0ar1x8-TaU5o';

Future<String> sendNotification(String title, String body, String device, String id) async {
  // prepare JSON for request
  String reqJson = json.encode(SendNotificationRequest(
    notification: Notification(body: body, title: title),
    priority: 'high',
    data: NotificationData(
      clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      id: id,
      status: 'done',
    ),
    device: device,
  ));
  print('sendNotification:' + reqJson);
  // make POST request
  Response response = await post('https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: reqJson);

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var messageId = result['message_id'];
    if (messageId != null) {
      return 'OK';
    } else
      return 'No response: ' + result.toString();
  } else
    return 'Technical error: ' + response.statusCode.toString();
}

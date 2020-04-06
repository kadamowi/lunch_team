class Notification {
  String body;
  String title;

  Notification({this.body,this.title});

  toJson() {
    return {
      'body': body,
      'title': title,
    };
  }
}

class NotificationData {
  String clickAction;
  String id;
  String status;

  NotificationData({this.clickAction,this.id,this.status});

  toJson() {
    return {
      'click_action': clickAction,
      'id': id,
      'status': status
    };
  }
}

class SendNotificationRequest {
  Notification notification;
  String priority;
  NotificationData data;
  String device;

  SendNotificationRequest({this.notification,this.priority,this.data,this.device});

  toJson() {
    return {
      'notification': notification,
      'priority': priority,
      'data': data,
      'to': device,
    };
  }
}
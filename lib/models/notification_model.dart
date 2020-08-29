class NotificationModel {
  final String columnId = '_id';
  final String mapTitle = 'title';
  final String mapBody = 'body';
  final String mapReceivedAt = 'received_at';
  int id;
  String title;
  String body;
  dynamic data;
  ACTION action;
  String receivedAt;

//  NotificationModel.fromJson();

  NotificationModel(
      {this.title, this.body, this.data, this.action, this.receivedAt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mapTitle: title,
      mapBody: body,
      mapReceivedAt: receivedAt
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  NotificationModel.fromMap(Map<String, dynamic> parsedJson){
    title = parsedJson[mapTitle];
    body = parsedJson[mapBody];
    receivedAt = parsedJson[mapReceivedAt];
    id = parsedJson[columnId];
  }
}

enum ACTION { ORDER_RECEIVED, ORDER_DELIVERED, CLEAR_DUES }

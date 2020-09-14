import 'package:nextdoorpartner/util/date_converter.dart';

class NotificationModel {
  final String columnId = '_id';
  final String mapTitle = 'title';
  final String mapBody = 'body';
  final String mapAction = 'action';
  final String mapReceivedAt = 'received_at';
  final String mapCreatedAt = 'createdAt';
  int id;
  String title;
  String body;
  dynamic data;
  //TODO: action set enum
  String action;
  String receivedAt;

//  NotificationModel.fromJson();

  NotificationModel(
      {this.title, this.body, this.data, this.action, this.receivedAt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mapTitle: title,
      mapBody: body,
      mapReceivedAt: receivedAt,
      mapAction: action
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  NotificationModel.fromMap(Map<String, dynamic> parsedJson) {
    title = parsedJson[mapTitle];
    body = parsedJson[mapBody];
    receivedAt = parsedJson[mapReceivedAt];
    id = parsedJson[columnId];
    action = parsedJson[mapAction];
  }

  NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson[mapTitle];
    body = parsedJson[mapBody];
    receivedAt = DateConverter.convert(parsedJson[mapCreatedAt]);
    action = parsedJson[mapAction];
  }
}

enum ACTION { ORDER_RECEIVED, ORDER_DELIVERED, CLEAR_DUES }

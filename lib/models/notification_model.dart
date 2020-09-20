import 'package:nextdoorpartner/util/date_converter.dart';

class NotificationModel {
  final String columnId = '_id';
  final String mapTitle = 'title';
  final String mapBody = 'body';
  final String mapAction = 'action';
  final String mapData = 'data';
  final String mapReceivedAt = 'received_at';
  final String mapCreatedAt = 'createdAt';
  final String mapScreen = 'screen';
  int id;
  String title;
  String body;
  PayloadData data;
  String receivedAt;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mapTitle: title,
      mapBody: body,
      mapReceivedAt: receivedAt,
      mapData: data,
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
    data = PayloadData.fromJson(parsedJson[mapData]);
    id = parsedJson[columnId];
  }

  NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson[mapTitle];
    body = parsedJson[mapBody];
    receivedAt = DateConverter.convert(parsedJson[mapCreatedAt]);
    data = parsedJson[mapData];
  }
}

class PayloadData {
  int id;
  String screen;
  Action action;
  PayloadData.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey('id')) {
      id = parsedJson['id'];
    }
    if (parsedJson.containsKey('screen')) {
      screen = parsedJson['screen'];
      if (screen == 'NEW_ORDER') {
        action = Action.NEW_ORDER;
      } else if (screen == 'ORDER') {
        action = Action.ORDER;
      }
    }
  }
}

enum Action { ORDER, NEW_ORDER }

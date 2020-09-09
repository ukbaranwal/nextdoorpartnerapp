import 'package:nextdoorpartner/models/order_model.dart';

class OrderModelBloc {
  List<OrderModel> ordersModelListPending;
  List<OrderModel> ordersModelListConfirmed;
  List<OrderModel> ordersModelListDispatched;
  List<OrderModel> ordersModelListCompleted;
  int noOfOrdersPending;
  int noOfOrdersConfirmed;
  int noOfOrdersDispatched;
  int noOfOrdersCompleted;

  OrderModelBloc() {
    noOfOrdersPending = 0;
    noOfOrdersConfirmed = 0;
    noOfOrdersDispatched = 0;
    noOfOrdersCompleted = 0;
    ordersModelListPending = List<OrderModel>();
    ordersModelListConfirmed = List<OrderModel>();
    ordersModelListDispatched = List<OrderModel>();
    ordersModelListCompleted = List<OrderModel>();
  }

  parseOrderModelListPending(Map<String, dynamic> parsedJson) {
    noOfOrdersPending = parsedJson['orders']['count'];
    List<dynamic> parsedList = parsedJson['orders']['rows'];
    for (var i in parsedList) {
      ordersModelListPending.add(OrderModel.fromJson(i));
    }
  }

  parseOrderModelListConfirmed(Map<String, dynamic> parsedJson) {
    noOfOrdersConfirmed = parsedJson['orders']['count'];
    List<dynamic> parsedList = parsedJson['orders']['rows'];
    for (var i in parsedList) {
      ordersModelListConfirmed.add(OrderModel.fromJson(i));
    }
  }

  parseOrderModelListDispatched(Map<String, dynamic> parsedJson) {
    noOfOrdersDispatched = parsedJson['orders']['count'];
    List<dynamic> parsedList = parsedJson['orders']['rows'];
    for (var i in parsedList) {
      ordersModelListDispatched.add(OrderModel.fromJson(i));
    }
  }

  parseOrderModelListCompleted(Map<String, dynamic> parsedJson) {
    noOfOrdersCompleted = parsedJson['orders']['count'];
    List<dynamic> parsedList = parsedJson['orders']['rows'];
    for (var i in parsedList) {
      ordersModelListCompleted.add(OrderModel.fromJson(i));
    }
  }
}

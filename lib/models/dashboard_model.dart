import 'package:nextdoorpartner/models/order_model.dart';

enum OrderFilter { ALL, CONFIRMED, PENDING }

class DashboardModel {
  int noOfOrders;
  double revenue;
  int noOfRatings;
  double rating;
  List<int> ratingStars;
  List<OrderModel> allOrderModelList;
  List<OrderModel> orderModelList;

  DashboardModel.fromJson(Map<String, dynamic> parsedJson) {
    rating = parsedJson['rating']['rating'];
    noOfRatings = parsedJson['rating']['no_of_ratings'];
    ratingStars = List<int>();
    for (var i in parsedJson['rating']['rating_stars']) {
      ratingStars.add(i);
    }
    allOrderModelList = List<OrderModel>();
    for (var i in parsedJson['orders']) {
      allOrderModelList.add(OrderModel.fromJson(i));
    }
    orderModelList = List<OrderModel>();
    orderModelList = allOrderModelList;
  }

  filter(OrderFilter orderFilter) {
    if (orderFilter == OrderFilter.ALL) {
      orderModelList = List<OrderModel>();
      orderModelList = allOrderModelList;
    } else if (orderFilter == OrderFilter.CONFIRMED) {
      orderModelList = List<OrderModel>();
      for (OrderModel orderModel in allOrderModelList) {
        if (orderModel.status == OrderStatus.CONFIRMED) {
          orderModelList.add(orderModel);
        }
      }
    } else {
      orderModelList = List<OrderModel>();
      for (OrderModel orderModel in allOrderModelList) {
        if (orderModel.status == OrderStatus.PENDING) {
          orderModelList.add(orderModel);
        }
      }
    }
  }

  fromRevenueJson(Map<String, dynamic> parsedJson) {
    noOfOrders = parsedJson['order_count'];
    revenue = parsedJson['revenue'].toDouble();
  }
}

import 'package:nextdoorpartner/models/order_model.dart';

class DashboardModel {
  int noOfOrders;
  double revenue;
  int noOfRatings;
  double rating;
  List<int> ratingStars;
  List<OrderModel> orderModelList;

  DashboardModel.fromJson(Map<String, dynamic> parsedJson) {
    rating = parsedJson['rating']['rating'];
    noOfRatings = parsedJson['rating']['no_of_ratings'];
    ratingStars = List<int>();
    for (var i in parsedJson['rating']['rating_stars']) {
      ratingStars.add(i);
    }
    orderModelList = List<OrderModel>();
    for (var i in parsedJson['orders']) {
      orderModelList.add(OrderModel.fromJson(i));
    }
  }

  fromRevenueJson(Map<String, dynamic> parsedJson) {
    noOfOrders = parsedJson['order_count'];
    revenue = parsedJson['revenue'].toDouble();
  }
}

class EndDrawerModel {
  String shopName;
  String address;
  String email;
  String phone;
  String imageUrl;

  EndDrawerModel(
      this.shopName, this.address, this.email, this.phone, this.imageUrl);
}

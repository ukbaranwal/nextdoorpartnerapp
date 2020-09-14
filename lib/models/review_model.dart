import 'package:nextdoorpartner/util/date_converter.dart';

class ReviewModel {
  int orderNo;
  double amount;
  String deliveredAt;
  int units;
  String products;
  int rating;
  String review;
  ReviewModel.fromJson(Map<String, dynamic> parsedJson) {
    orderNo = parsedJson['id'];
    amount = parsedJson['amount'].toDouble();
    deliveredAt = DateConverter.convert(parsedJson['delivered_at']);
    units = parsedJson['units'];
    products = '';
    for (var i in parsedJson['products']) {
      products = products + i['product_name'] + ', ';
    }
    products = products.substring(0, products.length - 2);
    rating = parsedJson['rating'];
    review = parsedJson['review'];
    print(review);
  }
}

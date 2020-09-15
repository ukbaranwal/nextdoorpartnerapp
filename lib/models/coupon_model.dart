import 'dart:convert';

import 'package:jiffy/jiffy.dart';
import 'package:nextdoorpartner/util/date_converter.dart';

enum Applicability { ALL, PRODUCT_WISE, FIRST_TIMER }

class CouponModel {
  int id;
  String name;
  String description;
  String code;
  int discount;
  double maxDiscount;
  double minOrder;
  String startDate;
  String endDate;
  bool isLive;
  Applicability applicability;
  //List of Product or Product Category ID
  List<int> applicableOn;

  CouponModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    description = parsedJson['description'];
    maxDiscount = parsedJson['max_discount'].toDouble();
    minOrder = parsedJson['min_order'].toDouble();
    startDate = parsedJson['start_date'];

    endDate = parsedJson['end_date'];
    isLive = parsedJson['is_live'];
    code = parsedJson['code'];
    code = code.toUpperCase();
    discount = parsedJson['discount_percentage'];
    print(parsedJson['applicability']);
    if (parsedJson['applicability'] == Applicability.ALL.toString()) {
      applicability = Applicability.ALL;
    } else if (parsedJson['applicability'] ==
        Applicability.PRODUCT_WISE.toString()) {
      applicability = Applicability.PRODUCT_WISE;
    } else {
      applicability = Applicability.FIRST_TIMER;
    }
    if (applicability == Applicability.PRODUCT_WISE) {
      applicableOn = List<int>();
      for (var i in jsonDecode(parsedJson['applicable_on'])) {
        applicableOn.add(i);
      }
    }
  }

  CouponModel(
      this.name,
      this.description,
      this.code,
      this.discount,
      this.maxDiscount,
      this.minOrder,
      this.startDate,
      this.endDate,
      this.applicability,
      this.applicableOn);
}

import 'dart:convert';

import 'package:nextdoorpartner/util/date_converter.dart';

class OrderModel {
  int id;
  int orderId;
  bool paid;
  double amount;
  double amountPaidByWallet;
  double amountDue;
  double discountApplied;
  bool couponApplied;
  int couponId;
  double couponDiscount;
  String paymentMethod;
  double cashback;
  int units;
  String transactionId;
  String instructions;
  String status;
  bool cancelled;
  String review;
  double rating;
  String address;
  String packedAt;
  String shippedAt;
  String createdAt;
  String deliveredAt;
  String expectedDeliveryAt;
  List<OrderProductModel> products;

  final String mapId = 'id';
  final String mapColumnId = '_id';
  final String mapOrderId = 'order_id';
  final String mapPaid = 'paid';
  final String mapAmount = 'amount';
  final String mapAmountPaidByWallet = 'amount_paid_by_wallet';
  final String mapAmountDue = 'amount_due';
  final String mapDiscountApplied = 'discount_applied';
  final String mapCouponApplied = 'coupon_applied';
  final String mapCouponId = 'coupon_id';
  final String mapCouponDiscount = 'coupon_discount';
  final String mapPaymentMethod = 'payment_method';
  final String mapCashback = 'cashback';
  final String mapUnits = 'units';
  final String mapTransactionId = 'transaction_id';
  final String mapInstructions = 'instructions';
  final String mapStatus = 'status';
  final String mapCancelled = 'cancelled';
  final String mapReview = 'review';
  final String mapRating = 'rating';
  final String mapAddress = 'address';
  final String mapPackedAt = 'packed_at';
  final String mapShippedAt = 'shipped_at';
  final String mapCreatedAt = 'createdAt';
  final String mapDeliveredAt = 'delivered_at';
  final String mapExpectedDeliveryAt = 'expected_delivery_at';
  final String mapProducts = 'products';

  OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    orderId = parsedJson[mapId];
    paid = parsedJson[mapPaid];
    amount = convertIntToDouble(parsedJson[mapAmount]);
    amountPaidByWallet = convertIntToDouble(parsedJson[mapAmountPaidByWallet]);
    amountDue = convertIntToDouble(parsedJson[mapAmountDue]);
    discountApplied = convertIntToDouble(parsedJson[mapDiscountApplied]);
    couponApplied = parsedJson[mapCouponApplied];
    couponId = parsedJson[mapColumnId];
    couponDiscount = convertIntToDouble(parsedJson[mapCouponDiscount]);
    paymentMethod = parsedJson[mapPaymentMethod];
    cashback = convertIntToDouble(parsedJson[mapCashback]);
    units = parsedJson[mapUnits];
    transactionId = parsedJson[mapTransactionId];
    instructions = parsedJson[mapInstructions];
    status = parsedJson[mapStatus];
    cancelled = parsedJson[mapCancelled];
    review = jsonEncode(parsedJson[mapReview]);
    rating = convertIntToDouble(parsedJson[mapRating]);
    address = jsonEncode(parsedJson[mapAddress]);
    packedAt = DateConverter.convert(parsedJson[mapPackedAt]);
    shippedAt = DateConverter.convert(parsedJson[mapShippedAt]);
    createdAt = DateConverter.convert(parsedJson[mapCreatedAt]);
    deliveredAt = DateConverter.convert(parsedJson[mapDeliveredAt]);
    expectedDeliveryAt =
        DateConverter.convert(parsedJson[mapExpectedDeliveryAt]);
    dynamic tempProducts = parsedJson[mapProducts];
    products = List<OrderProductModel>();
    for (dynamic product in tempProducts) {
      products.add(OrderProductModel.fromJson(product));
    }
  }
  double convertIntToDouble(int value) {
    if (value == null) {
      return 0.0;
    }
    return double.parse(value.toString());
  }
}

class OrderProductModel {
  int productId;
  String productName;
  String productBrand;
  double amount;
  double discountApplied;
  int quantity;
  String image;
  final String mapProductId = 'product_id';
  final String mapProductName = 'product_name';
  final String mapProductBrand = 'product_brand';
  final String mapAmount = 'amount';
  final String mapDiscountApplied = 'discount_applied';
  final String mapQuantity = 'quantity';
  final String mapImage = 'image';
  OrderProductModel.fromJson(Map<String, dynamic> parsedJson) {
    productId = parsedJson[mapProductId];
    productName = parsedJson[mapProductName];
    productBrand = parsedJson[mapProductBrand];
    amount = convertIntToDouble(parsedJson[mapAmount]);
    discountApplied = convertIntToDouble(parsedJson[mapDiscountApplied]);
    quantity = parsedJson[quantity];
    image = parsedJson[mapImage];
  }

  double convertIntToDouble(int value) {
    if (value == null) {
      return 0.0;
    }
    return double.parse(value.toString());
  }
}

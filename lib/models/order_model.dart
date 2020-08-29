import 'dart:convert';

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
  DateTime packedAt;
  DateTime shippedAt;
  DateTime createdAt;
  DateTime deliveredAt;
  DateTime expectedDeliveryAt;
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
    amount = parsedJson[mapAmount];
    amountPaidByWallet = parsedJson[mapAmountPaidByWallet];
    amountDue = parsedJson[mapAmountDue];
    discountApplied = parsedJson[mapDiscountApplied];
    couponApplied = parsedJson[mapCouponApplied];
    couponId = parsedJson[mapColumnId];
    couponDiscount = parsedJson[mapCouponDiscount];
    paymentMethod = parsedJson[mapPaymentMethod];
    cashback = parsedJson[mapCashback];
    units = parsedJson[mapUnits];
    transactionId = parsedJson[mapTransactionId];
    instructions = parsedJson[mapInstructions];
    status = parsedJson[mapStatus];
    cancelled = parsedJson[mapCancelled];
    review = jsonEncode(parsedJson[mapReview]);
    rating = parsedJson[mapRating];
    address = jsonEncode(parsedJson[mapAddress]);
    packedAt = parsedJson[mapPackedAt];
    shippedAt = parsedJson[mapShippedAt];
    createdAt = parsedJson[mapCreatedAt];
    deliveredAt = parsedJson[mapDeliveredAt];
    expectedDeliveryAt = parsedJson[mapExpectedDeliveryAt];
    dynamic tempProducts = parsedJson[mapProducts];
    products = List<OrderProductModel>();
    for (dynamic product in tempProducts) {
      products.add(OrderProductModel.fromJson(product));
    }
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
    amount = parsedJson[mapAmount];
    discountApplied = parsedJson[mapDiscountApplied];
    quantity = parsedJson[quantity];
    image = parsedJson[mapImage];
  }
}

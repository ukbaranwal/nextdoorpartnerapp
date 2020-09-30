import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/vendor_api_provider.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';
import 'package:nextdoorpartner/ui/dashboard.dart';
import 'package:nextdoorpartner/ui/products.dart';

class Repository {
  final vendorApiProvider = VendorApiProvider();
  final vendorDatabaseProvider = VendorDatabaseProvider();

  Future<Response> doSignUp(String name, String email, String phone,
          String city, String password, String deviceId) =>
      vendorApiProvider.doSignUp(name, email, phone, city, password, deviceId);

  Future<Response> doLogin(String email, String password, String deviceId) =>
      vendorApiProvider.doLogin(email, password, deviceId);

  Future<Response> requestResetPin(String email) =>
      vendorApiProvider.requestResetPin(email);

  Future<Response> resetPassword(String email, String pin, String password) =>
      vendorApiProvider.resetPassword(email, pin, password);

  Future<Response> changePassword(String password, String newPassword) =>
      vendorApiProvider.changePassword(password, newPassword);

  Future<Response> getDashboard() => vendorApiProvider.getDashboard();

  Future<Response> firebaseTokenUpload() =>
      vendorApiProvider.firebaseTokenUpload();

  Future<Response> getDashboardRevenue(RevenueDuration revenueDuration) =>
      vendorApiProvider.getDashboardRevenue(revenueDuration);

  Future<Response> changeShopStatus(bool shopOpen) =>
      vendorApiProvider.changeShopStatus(shopOpen);

  Future<Response> syncProductCategories(int vendorType) =>
      vendorApiProvider.syncProductCategories(vendorType);

  Future<bool> insertProductCategories(
          List<ProductCategoryModel> productCategoryModelList) =>
      vendorDatabaseProvider.insertProductCategories(productCategoryModelList);

  Future<Response> syncNotifications(String authorisationToken) =>
      vendorApiProvider.syncNotifications(authorisationToken);

  Future<bool> insertNotifications(
          List<NotificationModel> notificationModelList) =>
      vendorDatabaseProvider.insertNotifications(notificationModelList);

  Future<Response> deleteNotifications() =>
      vendorApiProvider.deleteNotifications();

  Future<Response> getProducts(int noOfProductsAlreadyFetched, String search,
          {ORDER_BY orderBy}) =>
      vendorApiProvider.getProducts(noOfProductsAlreadyFetched, search,
          orderBy: orderBy);

  Future<Response> getCouponProducts(
          int noOfProductsAlreadyFetched, List<int> productIds) =>
      vendorApiProvider.getCouponProducts(
          noOfProductsAlreadyFetched, productIds);

  Future<Response> getProductTemplates(int noOfProductsAlreadyFetched,
          String search, int productCategoryId) =>
      vendorApiProvider.getProductTemplates(
          noOfProductsAlreadyFetched, search, productCategoryId);

  Future<StreamedResponse> addProduct(
          ProductModel productModel, List<File> files) =>
      vendorApiProvider.addProduct(productModel, files);

  Future<Response> updateProduct(
          int id,
          String name,
          String brand,
          String description,
          double standardQuantity,
          double mrp,
          int discount,
          int productCategoryId) =>
      vendorApiProvider.updateProduct(id, name, brand, description,
          standardQuantity, mrp, discount, productCategoryId);

  Future<ProductCategoryModel> getProductCategory(int id) =>
      vendorDatabaseProvider.getProductCategory(id);

  Future<Response> deleteProductImage(int productId, String imageUrl) =>
      vendorApiProvider.deleteProductImage(productId, imageUrl);

  Future<StreamedResponse> addProductImage(int id, File file) =>
      vendorApiProvider.addProductImage(id, file);

  Future<Response> toggleInStock(int productId, bool inStock) =>
      vendorApiProvider.toggleInStock(productId, inStock);

  Future<List<NotificationModel>> getNotifications() =>
      vendorDatabaseProvider.getNotifications();

  Future<NotificationModel> insertNotificationInDb(
          NotificationModel notificationModel) =>
      vendorDatabaseProvider.insertNotification(notificationModel);

  Future<Response> getReviews(int noOfReviewsAlreadyFetched, int rating) =>
      vendorApiProvider.getReviews(noOfReviewsAlreadyFetched, rating);

  Future<Response> getOrders(int noOfOrdersAlreadyFetched, String status) =>
      vendorApiProvider.getOrders(noOfOrdersAlreadyFetched, status);

  Future<Response> getOrder(int orderId) => vendorApiProvider.getOrder(orderId);

  Future<Response> confirmOrder(int orderId) =>
      vendorApiProvider.confirmOrder(orderId);

  Future<Response> cancelOrder(int orderId, String cancellationReason) =>
      vendorApiProvider.cancelOrder(orderId, cancellationReason);

  Future<Response> registerComplaint(
          String contactInfo, String reason, String complaint) =>
      vendorApiProvider.registerComplaint(contactInfo, reason, complaint);

  Future<StreamedResponse> addBanner(File file) =>
      vendorApiProvider.addBanner(file);

  Future<Response> deleteBanner(String url) =>
      vendorApiProvider.deleteBanner(url);

  Future<Response> getHelpTabs() => vendorApiProvider.getHelpTabs();

  Future<Response> getHelpContent(int index) =>
      vendorApiProvider.getHelpContent(index);

  Future<Response> addCoupon(CouponModel couponModel) =>
      vendorApiProvider.addCoupon(couponModel);

  Future<Response> updateCoupon(CouponModel couponModel) =>
      vendorApiProvider.updateCoupon(couponModel);

  Future<Response> deleteCoupon(int couponId) =>
      vendorApiProvider.deleteCoupon(couponId);

  Future<Response> getCoupons() => vendorApiProvider.getCoupons();

  Future<Response> toggleIsLive(int couponId, bool isLive) =>
      vendorApiProvider.toggleIsLive(couponId, isLive);

  Future<Response> getColorVariants() => vendorApiProvider.getColorVariants();

  Future<Response> getSizeVariants() => vendorApiProvider.getSizeVariants();
}

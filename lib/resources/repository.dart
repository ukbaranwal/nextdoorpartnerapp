import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/vendor_api_provider.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';

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

  Future<Response> syncProductCategories(int vendorType) =>
      vendorApiProvider.syncProductCategories(vendorType);

  Future<bool> insertProductCategories(
          List<ProductCategoryModel> productCategoryModelList) =>
      vendorDatabaseProvider.insertProductCategories(productCategoryModelList);

  Future<Response> getProducts(int noOfProductsAlreadyFetched) =>
      vendorApiProvider.getProducts(noOfProductsAlreadyFetched);

  Future<StreamedResponse> addProduct(
          ProductModel productModel, List<File> files) =>
      vendorApiProvider.addProduct(productModel, files);

  Future<ProductCategoryModel> getProductCategory(int id) =>
      vendorDatabaseProvider.getProductCategory(id);

  Future<Response> deleteProductImage(int productId, String imageUrl) =>
      vendorApiProvider.deleteProductImage(productId, imageUrl);

  Future<List<NotificationModel>> getNotifications() =>
      vendorDatabaseProvider.getNotifications();

  Future<NotificationModel> insertNotificationInDb(
          NotificationModel notificationModel) =>
      vendorDatabaseProvider.insertNotification(notificationModel);
}

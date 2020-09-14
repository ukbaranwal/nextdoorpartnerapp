import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';

class BackgroundSyncBloc {
  final _repository = Repository();

  Future<ApiResponse> syncProductCategories(int vendorType) async {
    try {
      Response response = await _repository.syncProductCategories(vendorType);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.successful(jsonResponse['message'],
            data: jsonResponse['data']['product_categories']);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error(e.toString());
    }
    return ApiResponse.error('Something went Wrong');
  }

  Future<DbResponse> insertProductCategoriesInDb(
      List<ProductCategoryModel> productCategoryModelList) async {
    try {
      await _repository.insertProductCategories(productCategoryModelList);
      return DbResponse.successful('Loaded');
    } catch (e) {
      print(e.toString());
      return DbResponse.error(e.toString());
    }
  }

  Future<ApiResponse> syncNotifications(String authorisationToken) async {
    try {
      Response response =
          await _repository.syncNotifications(authorisationToken);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(jsonResponse);
        return ApiResponse.successful(jsonResponse['message'],
            data: jsonResponse['data']['notifications']);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error(e.toString());
    }
    return ApiResponse.error('Something went Wrong');
  }

  Future<DbResponse> insertNotificationsInDb(
      List<NotificationModel> notificationModelList) async {
    try {
      await _repository.insertNotifications(notificationModelList);
      await _repository.deleteNotifications();
      return DbResponse.successful('Loaded');
    } catch (e) {
      print(e.toString());
      return DbResponse.error(e.toString());
    }
  }
}

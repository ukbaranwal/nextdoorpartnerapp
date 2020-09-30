import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/ui/dashboard.dart';
import 'package:nextdoorpartner/ui/products.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exception.dart';

class VendorApiProvider {
  Client client = Client();
//  final String _baseUrl =
//      'http://nextdoor-dev.ap-south-1.elasticbeanstalk.com/vendors';
  static final String _baseUrl = 'https://nextdooor.herokuapp.com/vendors';
  Future<Response> doSignUp(String name, String email, String phone,
      String city, String password, String deviceId) async {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'password': password,
      'device_id': deviceId
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.post('$_baseUrl/signup',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> doLogin(
      String email, String password, String deviceId) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'device_id': deviceId
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.post('$_baseUrl/signin',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> requestResetPin(String email) async {
    Map<String, dynamic> data = {
      'email': email,
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.post('$_baseUrl/forgotPassword',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> resetPassword(
      String email, String pin, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'pin': pin,
      'password': password
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.put('$_baseUrl/forgotPassword',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> changePassword(String password, String newPassword) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    Map<String, dynamic> data = {
      'password': password,
      'new_password': newPassword
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/changePassword',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> firebaseTokenUpload() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    String token =
        sharedPreferences.getString(SharedPreferencesManager.firebaseToken);
    Map<String, dynamic> data = {'token': token};
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.put('$_baseUrl/firebaseToken',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getDashboard() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get('$_baseUrl/dashboard', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getDashboardRevenue(RevenueDuration revenueDuration) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/dashboardRevenue?duration=$revenueDuration',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> changeShopStatus(bool shopOpen) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/status?shop_open=$shopOpen',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> syncProductCategories(int vendorType) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/productCategory?vendor_type=$vendorType',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> syncNotifications(String authorisationToken) async {
    print('reach');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get('$_baseUrl/notification', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> deleteNotifications() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response =
          await client.delete('$_baseUrl/notification', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getProducts(int noOfProductsAlreadyFetched, String search,
      {ORDER_BY orderBy}) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    String tempOrderBy = '';
    if (orderBy == ORDER_BY.SOLD) {
      tempOrderBy = 'units_sold';
    } else if (orderBy == ORDER_BY.VIEWS) {
      tempOrderBy = 'views';
    } else if (orderBy == ORDER_BY.RATING) {
      tempOrderBy = 'rating';
    }
    var response;
    try {
      response = await client.get(
          '$_baseUrl/products?offset=$noOfProductsAlreadyFetched&search=$search&order_by=$tempOrderBy',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getCouponProducts(
      int noOfProductsAlreadyFetched, List<int> productIds) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/couponProducts?offset=$noOfProductsAlreadyFetched&product_ids=${productIds.toString()}',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getProductTemplates(int noOfProductsAlreadyFetched,
      String search, int productCategoryId) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/productTemplates?offset=$noOfProductsAlreadyFetched&product_category_id=$productCategoryId&search=$search',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<StreamedResponse> addProduct(
      ProductModel productModel, List<File> files) async {
    Map<String, String> data = {
      productModel.mapName: productModel.name,
      productModel.mapBrand: productModel.brand,
      productModel.mapDescription: productModel.description,
      productModel.mapProductCategoryId:
          productModel.productCategoryId.toString(),
      productModel.mapStandardQuantitySelling:
          productModel.standardQuantityOfSelling.toString(),
      productModel.mapMrp: productModel.mrp.toString(),
      productModel.mapDiscountPercentage:
          productModel.discountPercentage.toString(),
      'max_quantity': '1',
      productModel.mapTags: productModel.tags,
    };
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    print(authorisationToken);
    Map<String, String> headers = {
      "Authorization": authorisationToken,
      "Content-Type": "multipart/form-data"
    };
    print(data.toString());
    List<MultipartFile> tempMultipartFiles = List<MultipartFile>();
    for (File file in files) {
      tempMultipartFiles.add(await MultipartFile.fromPath('images', file.path,
          contentType: MediaType('image', 'jpeg')));
    }

    var response;
    try {
      MultipartRequest request =
          MultipartRequest('PUT', Uri.parse('$_baseUrl/product'));
      request.headers.addAll(headers);
      request.fields.addAll(data);
      request.files.addAll(tempMultipartFiles);
      response = await request.send();
      print(response.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<StreamedResponse> addProductImage(int id, File file) async {
    Map<String, dynamic> data = {'product_id': id};
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    print(authorisationToken);
    Map<String, String> headers = {
      "Authorization": authorisationToken,
      "Content-Type": "multipart/form-data"
    };
    print(data.toString());
    MultipartFile tempMultipartFile = await MultipartFile.fromPath(
        'image', file.path,
        contentType: MediaType('image', 'jpeg'));
    var response;
    try {
      MultipartRequest request =
          MultipartRequest('PUT', Uri.parse('$_baseUrl/productImage'));
      request.headers.addAll(headers);
      request.fields.addAll(data);
      request.files.add(tempMultipartFile);
      response = await request.send();
      print(response.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> deleteProductImage(int productId, String imageUrl) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.delete(
          '$_baseUrl/productImage?product_id=$productId&image_url=$imageUrl',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> toggleInStock(int productId, bool inStock) async {
    Map<String, dynamic> data = {'product_id': productId, 'in_stock': inStock};
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/productInStock',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> updateProduct(
      int id,
      String name,
      String brand,
      String description,
      double standardQuantity,
      double mrp,
      int discount,
      int productCategoryId) async {
    Map<String, dynamic> data = {
      'product_id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'product_category_id': productCategoryId,
      'standard_quantity_selling': standardQuantity,
      'mrp': mrp,
      'discount_percentage': discount,
      'max_quantity': '1',
      'tags': 'productModel.tags',
    };
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/product',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getReviews(int noOfReviewsAlreadyFetched, int rating) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/reviews?offset=$noOfReviewsAlreadyFetched${rating == -1 ? '' : '&rating=$rating'}',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getOrders(
      int noOfOrdersAlreadyFetched, String status) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get(
          '$_baseUrl/orders?offset=$noOfOrdersAlreadyFetched&status=$status',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getOrder(int orderId) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.get('$_baseUrl/order?order_id=$orderId',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> confirmOrder(int orderId) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    Map<String, dynamic> body = {
      "order_id": orderId,
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/orderConfirm',
          headers: headers, body: jsonEncode(body));
      print('$_baseUrl/orderConfirm');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future<Response> cancelOrder(int orderId, String cancellationReason) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    Map<String, dynamic> body = {
      "order_id": orderId,
      "cancellation_reason": cancellationReason
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/orderCancel',
          headers: headers, body: jsonEncode(body));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> registerComplaint(
      String contactInfo, String reason, String complaint) async {
    Map<String, dynamic> data = {
      'contact_info': contactInfo,
      'reason': reason,
      'complaint': complaint
    };
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken
    };
    var response;
    try {
      response = await client.post('$_baseUrl/complaint',
          body: jsonEncode(data), headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<StreamedResponse> addBanner(File file) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    print(authorisationToken);
    Map<String, String> headers = {
      "Authorization": authorisationToken,
      "Content-Type": "multipart/form-data"
    };
    MultipartFile tempMultipartFile = await MultipartFile.fromPath(
        'image', file.path,
        contentType: MediaType('image', 'jpeg'));
    var response;
    try {
      MultipartRequest request =
          MultipartRequest('PUT', Uri.parse('$_baseUrl/banner'));
      request.headers.addAll(headers);
      request.files.add(tempMultipartFile);
      response = await request.send();
      print(response.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> deleteBanner(String url) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.delete('$_baseUrl/banner?banner_url=$url',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getHelpTabs() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.get('$_baseUrl/helpTabs', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getHelpContent(int index) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.get('$_baseUrl/helpContent?index=$index',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> addCoupon(CouponModel couponModel) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    Map<String, dynamic> data = {
      'name': couponModel.name,
      'description': couponModel.description,
      'code': couponModel.code,
      'discount_percentage': couponModel.discount,
      'max_discount': couponModel.maxDiscount,
      'min_order': couponModel.minOrder,
      'start_date': couponModel.startDate,
      'end_date': couponModel.endDate,
      'applicability': couponModel.applicability.toString(),
      'applicable_on': couponModel.applicableOn.toString()
    };
    print(couponModel.applicability.toString());
    var response;
    try {
      response = await client.put('$_baseUrl/coupon',
          headers: headers, body: jsonEncode(data));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future<Response> updateCoupon(CouponModel couponModel) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    Map<String, dynamic> data = {
      'coupon_id': couponModel.id,
      'name': couponModel.name,
      'description': couponModel.description,
      'code': couponModel.code,
      'discount_percentage': couponModel.discount,
      'max_discount': couponModel.maxDiscount,
      'min_order': couponModel.minOrder,
      'start_date': couponModel.startDate,
      'end_date': couponModel.endDate,
      'applicability': couponModel.applicability.toString(),
      'applicable_on': couponModel.applicableOn.toString(),
    };
    print(data);
    var response;
    try {
      response = await client.patch('$_baseUrl/coupon',
          headers: headers, body: jsonEncode(data));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future<Response> deleteCoupon(int couponId) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.delete('$_baseUrl/coupon?coupon_id=$couponId',
          headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getCoupons() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    var response;
    try {
      response = await client.get('$_baseUrl/coupon', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> toggleIsLive(int couponId, bool isLive) async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    String authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": authorisationToken,
    };
    Map<String, dynamic> data = {
      "coupon_id": couponId,
      "is_live": isLive,
    };
    var response;
    try {
      response = await client.patch('$_baseUrl/couponStatus',
          headers: headers, body: jsonEncode(data));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getColorVariants() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.get('$_baseUrl/colorVariants', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }

  Future<Response> getSizeVariants() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var response;
    try {
      response = await client.get('$_baseUrl/sizeVariants', headers: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response;
  }
}

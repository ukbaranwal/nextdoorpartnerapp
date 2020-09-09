import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exception.dart';

class VendorApiProvider {
  Client client = Client();
//  final String _baseUrl =
//      'http://nextdoor-dev.ap-south-1.elasticbeanstalk.com/vendors';
  static final String _baseUrl = 'http://192.168.0.8:3003/vendors';
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

  Future<Response> getDashboardRevenue() async {
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
          await client.get('$_baseUrl/dashboardRevenue', headers: headers);
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

  Future<Response> getProducts(
      int noOfProductsAlreadyFetched, String search) async {
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
          '$_baseUrl/products?offset=$noOfProductsAlreadyFetched&search=$search',
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
}

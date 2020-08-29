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
  static final String _baseUrl = 'http://192.168.0.2:3003/vendors';
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
}

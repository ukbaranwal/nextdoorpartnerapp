import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';

import 'app_exception.dart';

class VendorApiProvider {
  Client client = Client();
  final String _baseUrl =
      'http://nextdoor-dev.ap-south-1.elasticbeanstalk.com/vendors';
  final String _authorisationKey = SharedPreferencesManager.authorisationKey;
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
}

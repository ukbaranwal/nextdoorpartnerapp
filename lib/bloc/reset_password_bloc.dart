import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordBloc {
  final _repository = Repository();
  SharedPreferences sharedPreferences;

  Future<ApiResponse> resetPassword(String pin, String password) async {
    try {
      sharedPreferences = await SharedPreferencesManager.getInstance();
      String email =
          sharedPreferences.getString(SharedPreferencesManager.email);
      Response response = await _repository.resetPassword(email, pin, password);

      ///no user exist with email
      if (response.statusCode == 204) {
        return ApiResponse.unSuccessful('No user exist with email $email');

        ///For accepted password 202
      } else {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 202) {
          return ApiResponse.successful(jsonResponse['message']);
        } else if (response.statusCode == 406) {
          return ApiResponse.unSuccessful(jsonResponse['message']);
        } else if (response.statusCode == 422) {
          return ApiResponse.validationFailed(jsonResponse['message']);
        } else {
          return ApiResponse.error(jsonResponse['message']);
        }
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error(e.toString());
    }
  }
}

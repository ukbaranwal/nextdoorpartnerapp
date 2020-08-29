import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordBloc {
  final _repository = Repository();

  Future<ApiResponse> requestResetPin(String email) async {
    try {
      Response response = await _repository.requestResetPin(email);

      ///no user exist with email
      if (response.statusCode == 204) {
        return ApiResponse.unSuccessful('No user exist with email $email');

        ///For accepted password 202
      } else {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (response.statusCode == 200) {
          SharedPreferences sharedPreferences =
              await SharedPreferencesManager.getInstance();
          sharedPreferences.setString(SharedPreferencesManager.email, email);
          return ApiResponse.successful(jsonResponse['message']);
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

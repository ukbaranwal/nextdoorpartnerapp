import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordBloc implements BlocInterface {
  final _repository = Repository();
  SharedPreferences sharedPreferences;
  var _resetPasswordFetcher = PublishSubject<ApiResponse<bool>>();
  Stream<ApiResponse<bool>> get resetPasswordStream =>
      _resetPasswordFetcher.stream;

  resetPassword(String pin, String password) async {
    try {
      _resetPasswordFetcher.sink.add(ApiResponse.hasData('Loading',
          actions: ApiActions.LOADING, loader: LOADER.SHOW));
      sharedPreferences = await SharedPreferencesManager.getInstance();
      String email =
          sharedPreferences.getString(SharedPreferencesManager.email);
      Response response = await _repository.resetPassword(email, pin, password);

      ///no user exist with email
      if (response.statusCode == 204) {
        _resetPasswordFetcher.sink.add(ApiResponse.hasData(
            'No user exist with email $email',
            actions: ApiActions.WRONG_INFO,
            loader: LOADER.HIDE));

        ///For accepted password 202
      } else {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 202) {
          _resetPasswordFetcher.sink.add(ApiResponse.hasData(
              jsonResponse['message'],
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE));
        } else if (response.statusCode == 406) {
          _resetPasswordFetcher.sink.add(ApiResponse.hasData(
              jsonResponse['message'],
              actions: ApiActions.WRONG_INFO,
              loader: LOADER.HIDE));
        } else {
          _resetPasswordFetcher.sink.add(ApiResponse.hasData(
              jsonResponse['message'],
              actions: ApiActions.ERROR,
              loader: LOADER.HIDE));
        }
      }
    } catch (e) {
      _resetPasswordFetcher.sink.add(ApiResponse.hasData(e.toString(),
          actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _resetPasswordFetcher.close();
  }
}

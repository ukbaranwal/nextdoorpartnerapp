import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordBloc implements BlocInterface {
  final _repository = Repository();
  SharedPreferences sharedPreferences;
  var _changePasswordFetcher = PublishSubject<ApiResponse<bool>>();
  Stream<ApiResponse<bool>> get changePasswordStream =>
      _changePasswordFetcher.stream;

  changePassword(String password, String newPassword) async {
    try {
      _changePasswordFetcher.sink.add(ApiResponse.hasData('Loading',
          actions: ApiActions.LOADING, loader: LOADER.SHOW));
      Response response =
          await _repository.changePassword(password, newPassword);

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 202) {
        _changePasswordFetcher.sink.add(ApiResponse.hasData(
            jsonResponse['message'],
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else if (response.statusCode == 401) {
        _changePasswordFetcher.sink.add(ApiResponse.hasData(
            jsonResponse['message'],
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      } else if (response.statusCode == 422) {
        _changePasswordFetcher.sink.add(ApiResponse.hasData(
            jsonResponse['message'],
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      } else {
        _changePasswordFetcher.sink.add(ApiResponse.error(
            jsonResponse['message'],
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      print(e.toString());
      _changePasswordFetcher.sink.add(ApiResponse.error(e.toString(),
          actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _changePasswordFetcher.close();
  }
}

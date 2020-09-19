import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordBloc implements BlocInterface {
  final _repository = Repository();
  var _forgotPasswordFetcher = PublishSubject<ApiResponse<bool>>();
  Stream<ApiResponse<bool>> get forgotPasswordStream =>
      _forgotPasswordFetcher.stream;

  requestResetPin(String email) async {
    try {
      _forgotPasswordFetcher.sink.add(ApiResponse.hasData('Loading',
          actions: ApiActions.LOADING, loader: LOADER.SHOW));
      Response response = await _repository.requestResetPin(email);

      ///no user exist with email
      if (response.statusCode == 204) {
        _forgotPasswordFetcher.sink.add(ApiResponse.hasData(
            'No user exist with email $email',
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));

        ///For accepted password 202
      } else {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (response.statusCode == 200) {
          SharedPreferences sharedPreferences =
              await SharedPreferencesManager.getInstance();
          sharedPreferences.setString(SharedPreferencesManager.email, email);
          _forgotPasswordFetcher.sink.add(ApiResponse.hasData(
              jsonResponse['message'],
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE));
        } else {
          _forgotPasswordFetcher.sink.add(ApiResponse.hasData(
              jsonResponse['message'],
              actions: ApiActions.ERROR,
              loader: LOADER.HIDE));
        }
      }
    } catch (e) {
      print(e.toString());
      _forgotPasswordFetcher.sink.add(ApiResponse.hasData(e.toString(),
          actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _forgotPasswordFetcher.close();
  }
}

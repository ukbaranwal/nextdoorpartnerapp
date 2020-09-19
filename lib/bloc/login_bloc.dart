import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BlocInterface {
  final _repository = Repository();
  var _loginFetcher = PublishSubject<ApiResponse<String>>();
  Stream<ApiResponse<String>> get loginStream => _loginFetcher.stream;

  doLogin(String email, String password, String deviceId) async {
    _loginFetcher = PublishSubject<ApiResponse<String>>();
    _loginFetcher.sink.add(ApiResponse.hasData('Loading',
        actions: ApiActions.LOADING, loader: LOADER.SHOW));
    try {
      Response response = await _repository.doLogin(email, password, deviceId);
      if (response.statusCode == 204) {
        _loginFetcher.sink.add(ApiResponse.hasData(
            'No user exist with email $email',
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      } else {
        var jsonResponse = jsonDecode(response.body);

        ///For Wrong Password 401
        if (response.statusCode == 401) {
          _loginFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
              actions: ApiActions.WRONG_INFO, loader: LOADER.HIDE));

          ///For accepted password 202
        } else if (response.statusCode == 202) {
          _loginFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE,
              data: VendorModel.fromJson(jsonResponse['data'])));

          ///No associated id 204
        } else {
          _loginFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
              actions: ApiActions.ERROR, loader: LOADER.HIDE));
        }
      }
    } catch (e) {
      print(e.toString());
      _loginFetcher.sink.add(ApiResponse.hasData(e.toString(),
          actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _loginFetcher.close();
  }
}

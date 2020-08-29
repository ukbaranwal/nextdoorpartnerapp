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
    try {
      Response response = await _repository.doLogin(email, password, deviceId);
      _loginFetcher.sink.add(ApiResponse.loading('Checking'));
      if (response.statusCode == 204) {
        _loginFetcher.sink
            .add(ApiResponse.unSuccessful('No user exist with email $email'));
      } else {
        var jsonResponse = jsonDecode(response.body);

        ///For Wrong Password 401
        if (response.statusCode == 401) {
          _loginFetcher.sink
              .add(ApiResponse.unSuccessful(jsonResponse['message']));

          ///For accepted password 202
        } else if (response.statusCode == 202) {
          _loginFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
              data: VendorModel.fromJson(jsonResponse['data'])));

          ///No associated id 204
        }

        ///Validation Failed 422
        else if (response.statusCode == 422) {
          _loginFetcher.sink
              .add(ApiResponse.validationFailed(jsonResponse['message']));
        } else {
          _loginFetcher.sink.add(ApiResponse.error(jsonResponse['message']));
        }
      }
    } catch (e) {
      print(e.toString());
      _loginFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _loginFetcher.close();
  }
}

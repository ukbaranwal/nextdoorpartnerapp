import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc implements BlocInterface {
  final _repository = Repository();
  var _signUpFetcher = PublishSubject<ApiResponse<String>>();
  Stream<ApiResponse<String>> get signUpStream => _signUpFetcher.stream;

  doSignUp(String name, String email, String phone, String city,
      String password, String deviceId) async {
    _signUpFetcher = PublishSubject<ApiResponse<String>>();
    try {
      Response response = await _repository.doSignUp(
          name, email, phone, city, password, deviceId);
      var jsonResponse = jsonDecode(response.body);
      _signUpFetcher.sink.add(ApiResponse.loading('Checking'));
      print(jsonResponse);

      ///already registered
      if (response.statusCode == 200) {
        _signUpFetcher.sink
            .add(ApiResponse.unSuccessful(jsonResponse['message']));

        ///successful sign up
      } else if (response.statusCode == 201) {
        _signUpFetcher.sink
            .add(ApiResponse.successful(jsonResponse['message']));

        ///validation failed
      } else if (response.statusCode == 422) {
        _signUpFetcher.sink
            .add(ApiResponse.validationFailed(jsonResponse['message']));

        ///server error
      } else {
        _signUpFetcher.sink.add(ApiResponse.error(jsonResponse['message']));
      }
    } catch (e) {
      print(e.toString());
      _signUpFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _signUpFetcher.close();
  }
}

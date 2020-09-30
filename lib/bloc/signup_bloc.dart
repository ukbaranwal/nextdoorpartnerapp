import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

///Bloc for sign up
class SignUpBloc implements BlocInterface {
  final _repository = Repository();
  var _signUpFetcher = PublishSubject<ApiResponse<String>>();
  Stream<ApiResponse<String>> get signUpStream => _signUpFetcher.stream;

  ///Requests signup
  doSignUp(String name, String email, String phone, String city,
      String password, String deviceId) async {
    try {
      _signUpFetcher.sink.add(ApiResponse.hasData('Loading',
          actions: ApiActions.LOADING, loader: LOADER.SHOW));
      Response response = await _repository.doSignUp(
          name, email, phone, city, password, deviceId);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      ///already registered
      if (response.statusCode == 200) {
        _signUpFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            actions: ApiActions.ERROR, loader: LOADER.HIDE));

        ///successful sign up
      } else if (response.statusCode == 201) {
        _signUpFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            actions: ApiActions.SUCCESSFUL, loader: LOADER.HIDE));

        ///validation failed
      } else {
        _signUpFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            actions: ApiActions.ERROR, loader: LOADER.HIDE));
      }
    } catch (e) {
      print(e.toString());
      _signUpFetcher.sink.add(ApiResponse.hasData(e.toString(),
          actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _signUpFetcher.close();
  }
}

import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SellerSupportBloc implements BlocInterface {
  final _repository = Repository();
  var _sellerSupportFetcher = PublishSubject<ApiResponse<String>>();
  Stream<ApiResponse<String>> get supportStream => _sellerSupportFetcher.stream;

  registerComplaint(String contactInfo, String reason, String complaint) async {
    try {
      _sellerSupportFetcher.sink.add(ApiResponse.loading('Checking'));
      Response response =
          await _repository.registerComplaint(contactInfo, reason, complaint);
      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse);

      ///already registered
      if (response.statusCode == 200) {
        _sellerSupportFetcher.sink
            .add(ApiResponse.successful(jsonResponse['message']));
      } else if (response.statusCode == 422) {
        _sellerSupportFetcher.sink
            .add(ApiResponse.validationFailed(jsonResponse['message']));

        ///server error
      } else {
        _sellerSupportFetcher.sink
            .add(ApiResponse.error(jsonResponse['message']));
      }
    } catch (e) {
      print(e.toString());
      _sellerSupportFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _sellerSupportFetcher.close();
  }
}

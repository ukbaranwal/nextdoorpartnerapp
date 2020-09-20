import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/help_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HelpPageBloc implements BlocInterface {
  final _repository = Repository();
  var _helpPageFetcher = PublishSubject<ApiResponse<HelpModel>>();
  Stream<ApiResponse<HelpModel>> get helpPageStream => _helpPageFetcher.stream;

  getHelpTabs() async {
    try {
      Response response = await _repository.getHelpTabs();
      var jsonResponse = jsonDecode(response.body);

      ///already registered
      if (response.statusCode == 200) {
        _helpPageFetcher.sink.add(ApiResponse.hasData('Fetched',
            data: HelpModel.fromJson(jsonResponse['tabs'])));
      } else {
        _helpPageFetcher.sink.add(ApiResponse.error(jsonResponse['message']));
      }
    } catch (e) {
      print(e.toString());
      _helpPageFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _helpPageFetcher.close();
  }
}

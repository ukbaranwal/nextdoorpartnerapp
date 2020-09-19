import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/help_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HelpPageContentBloc implements BlocInterface {
  final _repository = Repository();
  var _helpPageContentFetcher = PublishSubject<ApiResponse<String>>();
  Stream<ApiResponse<String>> get helpPageStream =>
      _helpPageContentFetcher.stream;

  getContent(int index) async {
    try {
      Response response = await _repository.getHelpContent(index);
      var jsonResponse = jsonDecode(response.body);

      ///already registered
      if (response.statusCode == 200) {
        _helpPageContentFetcher.sink
            .add(ApiResponse.hasData('Fetched', data: jsonResponse['content']));
      }
    } catch (e) {
      print(e.toString());
      _helpPageContentFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _helpPageContentFetcher.close();
  }
}

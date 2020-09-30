import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/color_variant_model.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ColorVariantsBloc implements BlocInterface {
  final _repository = Repository();
  var _colorFetcher = PublishSubject<ApiResponse<List<ColorVariantModel>>>();
  List<ColorVariantModel> colorModelList = List<ColorVariantModel>();
  Stream<ApiResponse<List<ColorVariantModel>>> get stream =>
      _colorFetcher.stream;

  getColors() async {
    try {
      Response response = await _repository.getColorVariants();
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse.toString());
      if (response.statusCode == 200) {
        for (var i in jsonResponse['color_variants']) {
          colorModelList.add(ColorVariantModel.fromJson(i));
        }
        _colorFetcher.sink
            .add(ApiResponse.hasData('Done', data: colorModelList));
      }
    } catch (e) {
      print(e.toString());
      _colorFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _colorFetcher.close();
  }
}

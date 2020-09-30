import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/color_variant_model.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/size_variants_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SizeVariantsBloc implements BlocInterface {
  final _repository = Repository();
  var _sizeFetcher = PublishSubject<ApiResponse<List<SizeVariantModel>>>();
  List<SizeVariantModel> sizeModelList = List<SizeVariantModel>();
  Stream<ApiResponse<List<SizeVariantModel>>> get stream => _sizeFetcher.stream;

  getSizes() async {
    try {
      Response response = await _repository.getSizeVariants();
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        for (var i in jsonResponse['size_variants']) {
          sizeModelList.add(SizeVariantModel.fromJson(i));
        }
        _sizeFetcher.sink.add(ApiResponse.hasData('Done', data: sizeModelList));
      }
    } catch (e) {
      print(e.toString());
      _sizeFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _sizeFetcher.close();
  }
}

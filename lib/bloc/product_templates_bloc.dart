import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_template_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductTemplatesBloc implements BlocInterface {
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _productTemplatesFetcher =
      PublishSubject<ApiResponse<List<ProductTemplateModel>>>();
  List<ProductTemplateModel> productTemplateModelList =
      List<ProductTemplateModel>();
  Stream<ApiResponse<List<ProductTemplateModel>>> get productsStream =>
      _productTemplatesFetcher.stream;
  String searchQuery = '';

  ProductTemplatesBloc() {
    productTemplateModelList = List<ProductTemplateModel>();
  }

  getProductTemplates(String search) async {
    if (alreadyExecuting) {
      return;
    }
    if (searchQuery != search) {
      productTemplateModelList = List<ProductTemplateModel>();
      searchQuery = search;
    }
    try {
      alreadyExecuting = true;
      Response response = await _repository.getProductTemplates(
          productTemplateModelList.length, searchQuery, 17);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['data']['product_templates'].length == 0) {
        _productTemplatesFetcher.sink
            .add(ApiResponse.hasData('end', data: productTemplateModelList));
        alreadyExecuting = false;
        return;
      }
      for (var i in jsonResponse['data']['product_templates']) {
        productTemplateModelList.add(ProductTemplateModel.fromJson(i));
      }
      _productTemplatesFetcher.sink
          .add(ApiResponse.hasData('Done', data: productTemplateModelList));
      alreadyExecuting = false;
    } catch (e) {
      print(e.toString());
      _productTemplatesFetcher.sink
          .add(ApiResponse.hasData('Done', data: productTemplateModelList));
    }
  }

  @override
  void dispose() {
    _productTemplatesFetcher.close();
  }
}

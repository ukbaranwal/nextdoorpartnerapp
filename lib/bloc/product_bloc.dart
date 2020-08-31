import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc implements BlocInterface {
  final _repository = Repository();
  var _productFetcher = PublishSubject<DbResponse<ProductModel>>();
  var _productApiFetcher = PublishSubject<ApiResponse<ProductModel>>();
  var _productCategoryFetcher =
      PublishSubject<DbResponse<ProductCategoryModel>>();
  Stream<ApiResponse<ProductModel>> get productApiStream =>
      _productApiFetcher.stream;
  Stream<DbResponse<ProductModel>> get productStream => _productFetcher.stream;

  Stream<DbResponse<ProductCategoryModel>> get productCategoryStream =>
      _productCategoryFetcher.stream;

  addProduct(ProductModel productModel, List<File> files) async {
    _productApiFetcher = PublishSubject<ApiResponse<ProductModel>>();
    try {
      _productApiFetcher.sink.add(ApiResponse.loading('Loading'));
      StreamedResponse streamedResponse =
          await _repository.addProduct(productModel, files);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          _productApiFetcher.sink.add(ApiResponse.successful(
              response['message'],
              data: response['data']));
        } else if (streamedResponse.statusCode == 422) {
          _productApiFetcher.sink
              .add(ApiResponse.validationFailed(response['message']));
        } else {
          _productApiFetcher.sink.add(ApiResponse.error(response['message']));
        }
      });
    } catch (e) {
      _productApiFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  getProductCategory(int id) async {
    _productCategoryFetcher =
        PublishSubject<DbResponse<ProductCategoryModel>>();
    try {
      _productCategoryFetcher.sink.add(DbResponse.loading('Checking'));
      ProductCategoryModel productCategoryModel =
          await _repository.getProductCategory(id);
      print(productCategoryModel.name.toString());
      _productCategoryFetcher.sink
          .add(DbResponse.successful('Done', data: productCategoryModel));
    } catch (e) {
      print(e.toString());
      _productCategoryFetcher.sink.add(DbResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _productFetcher.close();
    _productApiFetcher.close();
    _productCategoryFetcher.close();
  }
}

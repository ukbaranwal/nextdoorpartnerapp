import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_product_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CouponProductsBloc implements BlocInterface {
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _productsFetcher =
      PublishSubject<ApiResponse<List<CouponProductModel>>>();
  List<CouponProductModel> productModelList = List<CouponProductModel>();
  Stream<ApiResponse<List<CouponProductModel>>> get productsStream =>
      _productsFetcher.stream;
  String searchQuery = '';

  CouponProductsBloc(List<int> selectedIds) {
    productModelList = List<CouponProductModel>();
    if (selectedIds != null) {
      selectedProductIds = selectedIds;
    }
  }

  List<int> selectedProductIds = List<int>();

  getProducts(String search) async {
    if (alreadyExecuting) {
      return;
    }
    if (searchQuery != search) {
      productModelList = List<CouponProductModel>();
      searchQuery = search;
    }
    try {
      alreadyExecuting = true;
      Response response =
          await _repository.getProducts(productModelList.length, searchQuery);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['data']['products'].length.toString());
      if (jsonResponse['data']['products'].length == 0) {
        _productsFetcher.sink
            .add(ApiResponse.successful('end', data: productModelList));
        alreadyExecuting = false;
        return;
      }
      for (var i in jsonResponse['data']['products']) {
        productModelList.add(CouponProductModel(ProductModel.fromJson(i)));
        if (selectedProductIds
            .contains(productModelList.last.productModel.id)) {
          productModelList.last.isSelected = true;
        }
      }
      _productsFetcher.sink
          .add(ApiResponse.successful('Done', data: productModelList));
      alreadyExecuting = false;
    } catch (e) {
      print(e.toString());
      _productsFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  selectProduct(int index) {
    productModelList[index].isSelected = !productModelList[index].isSelected;
    if (productModelList[index].isSelected) {
      selectedProductIds.add(productModelList[index].productModel.id);
    } else {
      selectedProductIds.remove(productModelList[index].productModel.id);
    }
    _productsFetcher.sink
        .add(ApiResponse.successful('end', data: productModelList));
  }

  @override
  void dispose() {
    _productsFetcher.close();
  }
}

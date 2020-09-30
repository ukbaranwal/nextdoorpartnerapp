import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/ui/products.dart';
import 'package:rxdart/rxdart.dart';

///Bloc for list of products
class ProductsBloc implements BlocInterface {
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _productsFetcher = PublishSubject<ApiResponse<List<ProductModel>>>();
  List<ProductModel> productModelList = List<ProductModel>();
  Stream<ApiResponse<List<ProductModel>>> get productsStream =>
      _productsFetcher.stream;
  String searchQuery = '';

  ProductsBloc() {
    productModelList = List<ProductModel>();
  }

  ///Gets products according to search query
  ///Search Query can be null too
  getProducts(String search, {ORDER_BY orderBy}) async {
    if (alreadyExecuting) {
      return;
    }

    ///When search query is changed reinitialise the list
    if (searchQuery != search) {
      productModelList = List<ProductModel>();
      searchQuery = search;
    }
    try {
      alreadyExecuting = true;
      Response response = await _repository
          .getProducts(productModelList.length, searchQuery, orderBy: orderBy);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['data']['products'].toString());
        if (jsonResponse['data']['products'].length == 0) {
          _productsFetcher.sink
              .add(ApiResponse.hasData('end', data: productModelList));
          alreadyExecuting = false;
          return;
        }
        for (var i in jsonResponse['data']['products']) {
          productModelList.add(ProductModel.fromJson(i));
        }
        _productsFetcher.sink
            .add(ApiResponse.hasData('Done', data: productModelList));
      } else {
        _productsFetcher.sink
            .add(ApiResponse.hasData('Done', data: productModelList));
      }
      alreadyExecuting = false;
    } catch (e) {
      print(e.toString());
      _productsFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _productsFetcher.close();
  }
}

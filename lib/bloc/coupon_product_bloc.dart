import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_product_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

///Bloc for List of Products that will be used when user taps on Coupon Type for specific products
class CouponProductsBloc implements BlocInterface {
  ///This boolean used to make sure if
  ///it is already in between network call
  ///Functions can be called multiple times
  ///Since calls being made when user scroll down to bottom
  ///and since user will be hasty he can try for more than one time
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _productsFetcher =
      PublishSubject<ApiResponse<List<CouponProductModel>>>();

  ///List of Products
  List<CouponProductModel> productModelList = List<CouponProductModel>();
  Stream<ApiResponse<List<CouponProductModel>>> get productsStream =>
      _productsFetcher.stream;

  ///Search Query Parameter
  String searchQuery = '';

  ///Products ids are passed when user is updating coupon details and it was selected according to product ids
  CouponProductsBloc(List<int> selectedIds) {
    productModelList = List<CouponProductModel>();
    if (selectedIds != null) {
      selectedProductIds = selectedIds;
      staticSelectedProductIds = selectedIds;
    } else {
      staticSelectedProductIds = List<int>();
    }
  }

  ///To keep check about the selected ids
  List<int> selectedProductIds = List<int>();

  ///To keep count of previously selected ids
  ///Like when user goes on to edit products on which coupons can be used
  ///and then user wants to discard
  ///This variable stores the list of those product ids
  List<int> staticSelectedProductIds;

  ///Gets products according to search query
  ///Search Query can be null too
  getProducts(String search) async {
    if (alreadyExecuting) {
      return;
    }

    ///When search query is changed reinitialise the list
    if (searchQuery != search) {
      productModelList = List<CouponProductModel>();
      searchQuery = search;
    }
    try {
      alreadyExecuting = true;
      Response response;

      ///Retrieve only those products that was previous selected
      ///Called only when updating coupon not on adding
      ///10 products will still be in response
      ///if 5 products was previous selected other 5 will be non selected products
      if (productModelList.length < staticSelectedProductIds.length &&
          searchQuery == '') {
        response = await _repository.getCouponProducts(
            productModelList.length, staticSelectedProductIds);
      } else {
        response =
            await _repository.getProducts(productModelList.length, searchQuery);
      }
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['data']['products'].length.toString());

        ///When all the products has been fetched set message as end so this function won't be called again
        if (jsonResponse['data']['products'].length == 0) {
          _productsFetcher.sink.add(ApiResponse.hasData('end',
              data: productModelList, actions: ApiActions.INITIATED));
          alreadyExecuting = false;
          return;
        }
        for (var i in jsonResponse['data']['products']) {
          productModelList.add(CouponProductModel(ProductModel.fromJson(i)));

          ///if product id of product is in selectedProductIds list
          ///set isSelected True so check box is true
          if (selectedProductIds
              .contains(productModelList.last.productModel.id)) {
            productModelList.last.isSelected = true;
          }
        }
        _productsFetcher.sink.add(ApiResponse.hasData('Done',
            data: productModelList, actions: ApiActions.INITIATED));
      }
      alreadyExecuting = false;
    } catch (e) {
      print(e.toString());
      _productsFetcher.sink
          .add(ApiResponse.error(e.toString(), actions: ApiActions.ERROR));
    }
  }

  ///Select or deselect a product
  selectProduct(int index) {
    productModelList[index].isSelected = !productModelList[index].isSelected;
    if (productModelList[index].isSelected) {
      selectedProductIds.add(productModelList[index].productModel.id);
    } else {
      selectedProductIds.remove(productModelList[index].productModel.id);
    }
    _productsFetcher.sink.add(ApiResponse.hasData('end',
        data: productModelList, actions: ApiActions.SUCCESSFUL));
  }

  @override
  void dispose() {
    _productsFetcher.close();
  }
}

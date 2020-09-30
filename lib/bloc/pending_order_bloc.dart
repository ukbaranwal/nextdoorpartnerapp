import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/order_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

///Bloc for Pending Specific Order
class PendingOrderBloc implements BlocInterface {
  final _repository = Repository();
  var _orderFetcher = PublishSubject<ApiResponse<OrderModel>>();
  Stream<ApiResponse<OrderModel>> get orderStream => _orderFetcher.stream;

  ///TODO:
  int selectCount = 0;
  OrderModel _orderModel;

  ///Get Order Details
  getOrder(int orderId) async {
    try {
      Response response = await _repository.getOrder(orderId);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderModel = OrderModel.fromJson(jsonResponse['data']['order']);
        _orderFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _orderModel,
            actions: ApiActions.INITIATED,
            loader: LOADER.IDLE));
      } else {
        _orderFetcher.sink.add(
            ApiResponse.error(jsonResponse['message'], loader: LOADER.IDLE));
      }
    } catch (e) {
      _orderFetcher.sink.add(ApiResponse.error(e.toString(),
          loader: LOADER.IDLE, actions: ApiActions.ERROR));
    }
  }

  ///Confirm the order
  confirmOrder(int orderId) async {
    try {
      _orderFetcher.sink.add(ApiResponse.hasData('Loading',
          data: _orderModel, actions: ApiActions.LOADING, loader: LOADER.SHOW));
      Response response = await _repository.confirmOrder(orderId);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _orderModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _orderFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _orderModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
      }
    } catch (e) {
      _orderFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _orderModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  ///Cancels the order
  cancelOrder(int orderId, String cancellationReason) async {
    try {
      _orderFetcher.sink.add(ApiResponse.hasData('Loading',
          data: _orderModel, actions: ApiActions.LOADING, loader: LOADER.SHOW));
      Response response =
          await _repository.cancelOrder(orderId, cancellationReason);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _orderModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _orderFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _orderModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
      }
    } catch (e) {
      _orderFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _orderModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  ///TODO: The need of this
  select(int index, bool isSelected) {
    _orderModel.products[index].isSelected = isSelected;
    if (isSelected == true) {
      selectCount++;
    } else {
      selectCount--;
    }
    _orderModel.allProductSelected = _orderModel.products.length == selectCount;
    _orderFetcher.sink.add(ApiResponse.hasData('Selected',
        data: _orderModel,
        actions: ApiActions.SUCCESSFUL,
        loader: LOADER.IDLE));
  }

  ///TODO:
  selectAll(bool selectAll) {
    _orderModel.allProductSelected = selectAll;
    if (selectAll) {
      for (int i = 0; i < _orderModel.products.length; i++) {
        _orderModel.products[i].isSelected = true;
      }
    } else {
      for (int i = 0; i < _orderModel.products.length; i++) {
        _orderModel.products[i].isSelected = false;
      }
    }
    _orderFetcher.sink.add(ApiResponse.hasData('Selected',
        data: _orderModel,
        actions: ApiActions.SUCCESSFUL,
        loader: LOADER.IDLE));
  }

  @override
  void dispose() {
    _orderFetcher.close();
  }
}

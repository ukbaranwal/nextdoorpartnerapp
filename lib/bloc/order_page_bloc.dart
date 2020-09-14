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

class OrderPageBloc implements BlocInterface {
  final _repository = Repository();
  var _orderFetcher = PublishSubject<ApiResponse<OrderModel>>();
  Stream<ApiResponse<OrderModel>> get orderStream => _orderFetcher.stream;
  OrderModel _orderModel;

  getOrder(int orderId) async {
    try {
      Response response = await _repository.getOrder(orderId);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderModel = OrderModel.fromJson(jsonResponse['data']['order']);
        _orderFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _orderModel, showToast: false));
      }
    } catch (e) {
      _orderFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  confirmOrder(int orderId) async {
    try {
      Response response = await _repository.confirmOrder(orderId);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _orderModel, showToast: true));
      } else {
        _orderFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _orderModel, showToast: true));
      }
    } catch (e) {
//      _orderFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  cancelOrder(int orderId, String cancellationReason) async {
    try {
      Response response =
          await _repository.cancelOrder(orderId, cancellationReason);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _orderFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _orderModel, showToast: true));
      }
    } catch (e) {
      _orderFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _orderFetcher.close();
  }
}

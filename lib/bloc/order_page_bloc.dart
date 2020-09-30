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

///Bloc for Specific Order
class OrderPageBloc implements BlocInterface {
  final _repository = Repository();
  var _orderFetcher = PublishSubject<ApiResponse<OrderModel>>();
  Stream<ApiResponse<OrderModel>> get orderStream => _orderFetcher.stream;
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
      _orderFetcher.sink
          .add(ApiResponse.error(e.toString(), loader: LOADER.IDLE));
    }
  }

  @override
  void dispose() {
    _orderFetcher.close();
  }
}

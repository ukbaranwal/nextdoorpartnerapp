import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/order_model_bloc.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/Order_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc implements BlocInterface {
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _orderFetcher = PublishSubject<ApiResponse<OrderModelBloc>>();

  Stream<ApiResponse<OrderModelBloc>> get ordersStream => _orderFetcher.stream;
  String statusSelected;

  OrderModelBloc orderModelBloc;

  OrderBloc() {
    orderModelBloc = OrderModelBloc();
  }

  getOrders(int pageNo, {bool fromPagerView = false}) async {
    if (alreadyExecuting) {
      return;
    }
    if (fromPagerView) {
      if (pageNo == 0 && orderModelBloc.ordersModelListPending.length > 0) {
        return;
      } else if (pageNo == 1 &&
          orderModelBloc.ordersModelListConfirmed.length > 0) {
        return;
      } else if (pageNo == 2 &&
          orderModelBloc.ordersModelListDispatched.length > 0) {
        return;
      } else if (pageNo == 3 &&
          orderModelBloc.ordersModelListCompleted.length > 0) {
        return;
      }
    }
    try {
      String status;
      if (pageNo == 0) {
        status = 'Pending';
      } else if (pageNo == 1) {
        status = 'Confirmed';
      } else if (pageNo == 2) {
        status = 'Dispatched';
      } else {
        status = 'Completed';
      }
      alreadyExecuting = true;
      Response response;
      var jsonResponse;
      print(jsonResponse);
      if (status == 'Pending') {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListPending.length, status);
        jsonResponse = jsonDecode(response.body);
        orderModelBloc.parseOrderModelListPending(jsonResponse['data']);
      } else if (status == 'Confirmed') {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListConfirmed.length, status);
        jsonResponse = jsonDecode(response.body);
        orderModelBloc.parseOrderModelListConfirmed(jsonResponse['data']);
      } else if (status == 'Dispatched') {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListDispatched.length, status);
        jsonResponse = jsonDecode(response.body);
        orderModelBloc.parseOrderModelListDispatched(jsonResponse['data']);
      } else {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListCompleted.length, status);
        jsonResponse = jsonDecode(response.body);
        orderModelBloc.parseOrderModelListCompleted(jsonResponse['data']);
      }

      _orderFetcher.sink
          .add(ApiResponse.successful('done', data: orderModelBloc));
      alreadyExecuting = false;
    } catch (e) {
      print(e);
      _orderFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _orderFetcher.close();
  }
}

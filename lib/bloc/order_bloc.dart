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
import 'package:nextdoorpartner/util/constants.dart';
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
        status = Constants.pending;
      } else if (pageNo == 1) {
        status = Constants.confirmed;
      } else if (pageNo == 2) {
        status = Constants.dispatched;
      } else {
        status = Constants.completed;
      }
      alreadyExecuting = true;
      Response response;
      var jsonResponse;
      print(jsonResponse);
      if (status == Constants.pending) {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListPending.length, status);
        jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          orderModelBloc.parseOrderModelListPending(jsonResponse['data']);
        }
      } else if (status == Constants.confirmed) {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListConfirmed.length, status);
        jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          orderModelBloc.parseOrderModelListConfirmed(jsonResponse['data']);
        }
      } else if (status == Constants.dispatched) {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListDispatched.length, status);
        jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          orderModelBloc.parseOrderModelListDispatched(jsonResponse['data']);
        }
      } else {
        response = await _repository.getOrders(
            orderModelBloc.ordersModelListCompleted.length, status);
        jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          orderModelBloc.parseOrderModelListCompleted(jsonResponse['data']);
        }
      }

      _orderFetcher.sink.add(ApiResponse.hasData('done', data: orderModelBloc));
      alreadyExecuting = false;
    } catch (e) {
      print(e);
      _orderFetcher.sink
          .add(ApiResponse.hasData(e.toString(), data: orderModelBloc));
      alreadyExecuting = false;
    }
  }

  @override
  void dispose() {
    _orderFetcher.close();
  }
}

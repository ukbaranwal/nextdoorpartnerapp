import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/app_exception.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CouponBloc implements BlocInterface {
  final _repository = Repository();
  var _couponFetcher = PublishSubject<ApiResponse<CouponModel>>();
  Stream<ApiResponse<CouponModel>> get couponStream => _couponFetcher.stream;

  CouponModel _couponModel;
  CouponBloc(CouponModel couponModel) {
    _couponModel = couponModel;
  }

  addCoupon(CouponModel couponModel) async {
    try {
      Response response = await _repository.addCoupon(couponModel);
      var jsonResponse = jsonDecode(response.body);
      _couponFetcher.add(ApiResponse.successful(jsonResponse['message'],
          data: _couponModel, showToast: true));
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  updateCoupon(CouponModel couponModel) async {
    try {
      couponModel.id = _couponModel.id;
      couponModel.isLive = _couponModel.isLive;
      Response response = await _repository.updateCoupon(couponModel);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _couponModel = couponModel;
        _couponFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _couponModel, showToast: true));
      }
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  toggleIsLive() async {
    try {
      Response response =
          await _repository.toggleIsLive(_couponModel.id, !_couponModel.isLive);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _couponModel.isLive = !_couponModel.isLive;
        _couponFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: _couponModel, showToast: true));
      }
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 100));
    _couponFetcher.sink.add(ApiResponse.successful('Initiated',
        data: _couponModel, showToast: false));
  }

  @override
  void dispose() {
    _couponFetcher.close();
  }
}

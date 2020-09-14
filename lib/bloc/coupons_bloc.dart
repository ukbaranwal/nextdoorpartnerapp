import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CouponsBloc implements BlocInterface {
  final _repository = Repository();
  var _couponsFetcher = PublishSubject<ApiResponse<List<CouponModel>>>();
  List<CouponModel> couponModelList = List<CouponModel>();
  Stream<ApiResponse<List<CouponModel>>> get couponsStream =>
      _couponsFetcher.stream;
  String searchQuery = '';

  CouponsBloc() {
    couponModelList = List<CouponModel>();
  }

  getCoupons() async {
    try {
      Response response = await _repository.getCoupon();
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      for (var i in jsonResponse['data']['coupons']) {
        couponModelList.add(CouponModel.fromJson(i));
      }
      _couponsFetcher.sink
          .add(ApiResponse.successful('Done', data: couponModelList));
    } catch (e) {
      print(e.toString());
      _couponsFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _couponsFetcher.close();
  }
}

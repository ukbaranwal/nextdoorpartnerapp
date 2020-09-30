import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

///Bloc class for coupon page
class CouponBloc implements BlocInterface {
  final _repository = Repository();
  var _couponFetcher = PublishSubject<ApiResponse<CouponModel>>();
  Stream<ApiResponse<CouponModel>> get couponStream => _couponFetcher.stream;

  CouponModel _couponModel;
  CouponBloc(CouponModel couponModel) {
    _couponModel = couponModel;
  }

  ///Uploads new coupon to server
  ///Pass Coupon Model
  addCoupon(CouponModel couponModel) async {
    try {
      _couponFetcher.sink.add(ApiResponse.hasData('loading',
          data: _couponModel,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      Response response = await _repository.addCoupon(couponModel);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _couponModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  ///Updates or edit coupon details
  updateCoupon(CouponModel couponModel) async {
    try {
      _couponFetcher.sink.add(ApiResponse.hasData('loading',
          data: _couponModel,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));

      couponModel.id = _couponModel.id;
      couponModel.isLive = _couponModel.isLive;
      Response response = await _repository.updateCoupon(couponModel);
      var jsonResponse = jsonDecode(response.body);

      ///On successful operation
      if (response.statusCode == 200) {
        _couponModel = couponModel;
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _couponModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  ///Called to make a coupon live or offline
  toggleIsLive() async {
    try {
      _couponFetcher.sink.add(ApiResponse.hasData('loading',
          data: _couponModel,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      Response response =
          await _repository.toggleIsLive(_couponModel.id, !_couponModel.isLive);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _couponModel.isLive = !_couponModel.isLive;
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _couponFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _couponModel,
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _couponFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _couponModel, actions: ApiActions.ERROR, loader: LOADER.HIDE));
    }
  }

  ///Initialise bloc
  init() async {
    await Future.delayed(Duration(milliseconds: 100));
    _couponFetcher.sink.add(ApiResponse.hasData('Initiated',
        data: _couponModel,
        actions: ApiActions.INITIATED,
        loader: LOADER.IDLE));
  }

  @override
  void dispose() {
    _couponFetcher.close();
  }
}

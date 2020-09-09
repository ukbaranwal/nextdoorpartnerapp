import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/dashboard_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardBloc implements BlocInterface {
  final _repository = Repository();
  var _dashboardFetcher = PublishSubject<ApiResponse<DashboardModel>>();
  Stream<ApiResponse<DashboardModel>> get dashboardStream =>
      _dashboardFetcher.stream;

  DashboardModel _dashboardModel;

  DashboardBloc() {
    firebaseTokenUpload();
  }

  getDashboard() async {
    try {
      _dashboardFetcher.add(ApiResponse.loading('checking'));
      Response response = await _repository.getDashboard();
      Response revenueResponse = await _repository.getDashboardRevenue();
      print(response.toString());
      var jsonResponse = jsonDecode(response.body);
      var jsonRevenueResponse = jsonDecode(revenueResponse.body);
      print(jsonResponse.toString());
      print(jsonRevenueResponse.toString());
      _dashboardModel = DashboardModel.fromJson(jsonResponse['data']);
      _dashboardModel.fromRevenueJson(jsonRevenueResponse['data']);
      _dashboardFetcher.sink
          .add(ApiResponse.successful('Done', data: _dashboardModel));
    } catch (e) {
      print(e.toString());
      _dashboardFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  getDashboardRevenue() async {
    try {
      _dashboardFetcher.add(ApiResponse.loading('checking'));
      Response response = await _repository.getDashboardRevenue();
      var jsonResponse = jsonDecode(response.body);
      _dashboardModel.fromRevenueJson(jsonResponse['data']);
      _dashboardFetcher.sink
          .add(ApiResponse.successful('Done', data: _dashboardModel));
    } catch (e) {
      print(e.toString());
      _dashboardFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<bool> changeShopStatus() async {
    try {
      Response response =
          await _repository.changeShopStatus(!vendorModelGlobal.shopOpen);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool(
          SharedPreferencesManager.shopOpen, !vendorModelGlobal.shopOpen);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse.toString());
      _dashboardFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
          data: _dashboardModel, showToast: true));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  firebaseTokenUpload() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferencesManager.getInstance();
      bool isFirebaseTokenUploaded = sharedPreferences
              .getBool(SharedPreferencesManager.isFirebaseTokenUploaded) ??
          false;
      if (isFirebaseTokenUploaded) {
        return;
      }
      Response response = await _repository.firebaseTokenUpload();
      if (response.statusCode == 200) {
        sharedPreferences.setBool(
            SharedPreferencesManager.isFirebaseTokenUploaded, true);
      } else {
        sharedPreferences.setBool(
            SharedPreferencesManager.isFirebaseTokenUploaded, false);
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _dashboardFetcher.close();
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/dashboard_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/app_exception.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/ui/dashboard.dart';
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
      Response response = await _repository.getDashboard();
      Response revenueResponse =
          await _repository.getDashboardRevenue(RevenueDuration.LIFETIME);
      var jsonResponse = jsonDecode(response.body);
      var jsonRevenueResponse = jsonDecode(revenueResponse.body);
      if (response.statusCode == 200) {
        _dashboardModel = DashboardModel.fromJson(jsonResponse['data']);
        _dashboardModel.fromRevenueJson(jsonRevenueResponse['data']);
        _dashboardModel.revenueDuration = RevenueDuration.LIFETIME;
        _dashboardFetcher.sink
            .add(ApiResponse.hasData('Done', data: _dashboardModel));
      } else {
        _dashboardFetcher.sink.add(ApiResponse.error(jsonResponse['message']));
      }
    } catch (e) {
      if (e is FetchDataException) {
        _dashboardFetcher.sink.add(ApiResponse.socketError());
      } else {
        _dashboardFetcher.sink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  filter(OrderFilter orderFilter) {
    _dashboardModel.filter(orderFilter);
    _dashboardFetcher.sink
        .add(ApiResponse.hasData('Done', data: _dashboardModel));
  }

  getDashboardRevenue(RevenueDuration revenueDuration) async {
    try {
      Response response =
          await _repository.getDashboardRevenue(revenueDuration);
      var jsonResponse = jsonDecode(response.body);
      _dashboardModel.fromRevenueJson(jsonResponse['data']);
      _dashboardModel.revenueDuration = revenueDuration;
      _dashboardFetcher.sink
          .add(ApiResponse.hasData('Done', data: _dashboardModel));
    } catch (e) {
      print(e.toString());
      _dashboardFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<bool> changeShopStatus() async {
    try {
      _dashboardFetcher.sink.add(
          ApiResponse.hasData('Done', data: _dashboardModel, showLoader: true));
      Response response =
          await _repository.changeShopStatus(!vendorModelGlobal.shopOpen);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool(
            SharedPreferencesManager.shopOpen, !vendorModelGlobal.shopOpen);
        print(jsonResponse.toString());
        _dashboardFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _dashboardModel, showToast: true, showLoader: false));
      } else {
        _dashboardFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _dashboardModel, showToast: true, showLoader: false));
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  firebaseTokenUpload() async {
    try {
      return;
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

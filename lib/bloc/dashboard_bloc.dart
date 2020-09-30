import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/dashboard_model.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/app_exception.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/ui/dashboard.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Bloc for Homepage or Dashboard
class DashboardBloc implements BlocInterface {
  final _repository = Repository();
  var _dashboardFetcher = PublishSubject<ApiResponse<DashboardModel>>();
  Stream<ApiResponse<DashboardModel>> get dashboardStream =>
      _dashboardFetcher.stream;

  DashboardModel _dashboardModel;

  ///Get Dashboard Details
  getDashboard() async {
    try {
      Response response = await _repository.getDashboard();

      ///Order Count and Revenue
      Response revenueResponse =
          await _repository.getDashboardRevenue(RevenueDuration.LIFETIME);
      var jsonResponse = jsonDecode(response.body);
      var jsonRevenueResponse = jsonDecode(revenueResponse.body);
      print(response.statusCode);
      print(jsonResponse);
      if (response.statusCode == 200) {
        _dashboardModel = DashboardModel.fromJson(jsonResponse['data']);
        _dashboardModel.fromRevenueJson(jsonRevenueResponse['data']);

        ///selected duration of revenue and order count
        ///for dropdown
        _dashboardModel.revenueDuration = RevenueDuration.LIFETIME;
        _dashboardFetcher.sink.add(ApiResponse.hasData('Done',
            data: _dashboardModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.IDLE));
      } else {
        _dashboardFetcher.sink.add(ApiResponse.error(jsonResponse['message'],
            actions: ApiActions.ERROR, loader: LOADER.IDLE));
      }
    } catch (e) {
      print(e);
      if (e is FetchDataException) {
        _dashboardFetcher.sink.add(ApiResponse.socketError(
            loader: LOADER.IDLE, actions: ApiActions.ERROR));
      } else {
        _dashboardFetcher.sink
            .add(ApiResponse.error(e.toString(), loader: LOADER.IDLE));
      }
    }
  }

  ///Filter Active Orders Confirmed or Pending
  filter(OrderFilter orderFilter) {
    _dashboardModel.filter(orderFilter);
    _dashboardFetcher.sink.add(ApiResponse.hasData('Done',
        data: _dashboardModel,
        actions: ApiActions.SUCCESSFUL,
        loader: LOADER.IDLE));
  }

  ///Get Dashboard Revenue for specific Duration
  getDashboardRevenue(RevenueDuration revenueDuration) async {
    try {
      Response response =
          await _repository.getDashboardRevenue(revenueDuration);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        _dashboardModel.fromRevenueJson(jsonResponse['data']);
        _dashboardModel.revenueDuration = revenueDuration;
        _dashboardFetcher.sink.add(ApiResponse.hasData('Done',
            data: _dashboardModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.IDLE));
      }
    } catch (e) {
      print(e.toString());
      _dashboardFetcher.sink.add(ApiResponse.error(e.toString(),
          loader: LOADER.IDLE, actions: ApiActions.ERROR));
    }
  }

  ///Change status of Shop
  ///if shop is open or closed
  Future<bool> changeShopStatus() async {
    try {
      _dashboardFetcher.sink.add(ApiResponse.hasData('Done',
          data: _dashboardModel,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
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
            data: _dashboardModel,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _dashboardFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: _dashboardModel,
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
      return true;
    } catch (e) {
      _dashboardFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: _dashboardModel,
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
      return false;
    }
  }

  @override
  void dispose() {
    _dashboardFetcher.close();
  }
}

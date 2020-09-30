import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Bloc for Banners
class BannerBloc implements BlocInterface {
  final _repository = Repository();
  var _bannerFetcher = PublishSubject<ApiResponse<List<String>>>();
  Stream<ApiResponse<List<String>>> get bannerStream => _bannerFetcher.stream;

  ///Initialise the Bloc
  ///await is being used to make sure that it is properly initiated
  init() async {
    await Future.delayed(Duration(microseconds: 100));
    _bannerFetcher.sink
        .add(ApiResponse.hasData('Initiated', data: vendorModelGlobal.banners));
  }

  ///This function as name suggests uploads banners to server
  addBanner(File file) async {
    try {
      _bannerFetcher.sink.add(ApiResponse.hasData('Loading',
          data: vendorModelGlobal.banners,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      StreamedResponse streamedResponse = await _repository.addBanner(file);

      ///Streamed Response since request was a multipart request
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());

        ///201 for successful resource creation
        if (streamedResponse.statusCode == 201) {
          vendorModelGlobal.banners.add(response['data']['banner_url']);
          SharedPreferences sharedPreferences =
              await SharedPreferencesManager.getInstance();

          ///Store list of banners in Shared Preferences
          sharedPreferences.setStringList(
              SharedPreferencesManager.banners, vendorModelGlobal.banners);
          _bannerFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: vendorModelGlobal.banners,
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE));
        } else {
          _bannerFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: vendorModelGlobal.banners,
              actions: ApiActions.ERROR,
              loader: LOADER.HIDE));
        }
      });
    } catch (e) {
      _bannerFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: vendorModelGlobal.banners,
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
    }
  }

  ///Remove banner from server
  deleteBanner(int index) async {
    try {
      _bannerFetcher.sink.add(ApiResponse.hasData('Deleting',
          data: vendorModelGlobal.banners,
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      Response response =
          await _repository.deleteBanner(vendorModelGlobal.banners[index]);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ///Remove banner from global variable
        ///Then store it in sharedPreferences
        vendorModelGlobal.banners.removeAt(index);
        SharedPreferences sharedPreferences =
            await SharedPreferencesManager.getInstance();
        sharedPreferences.setStringList(
            SharedPreferencesManager.banners, vendorModelGlobal.banners);
        _bannerFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: vendorModelGlobal.banners,
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _bannerFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: vendorModelGlobal.banners,
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _bannerFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: vendorModelGlobal.banners,
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
    }
  }

  @override
  void dispose() {
    _bannerFetcher.close();
  }
}

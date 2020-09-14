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

class BannerBloc implements BlocInterface {
  final _repository = Repository();
  var _bannerFetcher = PublishSubject<ApiResponse<List<String>>>();
  Stream<ApiResponse<List<String>>> get bannerStream => _bannerFetcher.stream;

  init() async {
    await Future.delayed(Duration(microseconds: 100));
    _bannerFetcher.sink.add(
        ApiResponse.successful('Initiated', data: vendorModelGlobal.banners));
  }

  addBanner(File file) async {
    try {
      StreamedResponse streamedResponse = await _repository.addBanner(file);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          vendorModelGlobal.banners.add(response['data']['banner_url']);
          SharedPreferences sharedPreferences =
              await SharedPreferencesManager.getInstance();
          sharedPreferences.setStringList(
              SharedPreferencesManager.banners, vendorModelGlobal.banners);
          _bannerFetcher.sink.add(ApiResponse.successful(response['message'],
              data: vendorModelGlobal.banners, showToast: true));
        }
      });
    } catch (e) {
      _bannerFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  deleteBanner(int index) async {
    try {
      Response response =
          await _repository.deleteBanner(vendorModelGlobal.banners[index]);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        vendorModelGlobal.banners.removeAt(index);
        SharedPreferences sharedPreferences =
            await SharedPreferencesManager.getInstance();
        sharedPreferences.setStringList(
            SharedPreferencesManager.banners, vendorModelGlobal.banners);
        _bannerFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: vendorModelGlobal.banners, showToast: true));
      }
    } catch (e) {
      _bannerFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _bannerFetcher.close();
  }
}

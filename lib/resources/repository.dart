import 'package:http/http.dart';
import 'package:nextdoorpartner/resources/vendor_api_provider.dart';

class Repository {
  final vendorApiProvider = VendorApiProvider();

  Future<Response> doSignUp(String name, String email, String phone,
          String city, String password, String deviceId) =>
      vendorApiProvider.doSignUp(name, email, phone, city, password, deviceId);

  Future<Response> doLogin(String email, String password, String deviceId) =>
      vendorApiProvider.doLogin(email, password, deviceId);
}

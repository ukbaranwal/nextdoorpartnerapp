import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences _sharedPreferences;
  static String email = 'email';
  static String shopName = 'shopName';
  static String phone = 'phone';
  static String shopTime = 'shopTime';
  static String address = 'address';
  static String city = 'city';
  static String firebaseToken = 'firebaseToken';
  static String authorisationToken = 'authorisationToken';
  static String id = 'id';
  static String latitude = 'lat';
  static String longitude = 'long';
  static String isLoggedIn = 'isLoggedIn';
  static String isVerified = 'isVerified';
  static String vendorType = 'vendorType';
  static String imageUrl = 'imageUrl';
  static String name = 'name';
  static String shopOpen = 'shopOpen';
  static String optForDeliveryBoy = 'optForDeliveryBoy';
  static String localStore = 'localStore';
  static String upiId = 'upiId';
  static String paytmNo = 'paytmNo';
  static String membershipActive = 'membershipActive';
  static String openingTime = 'openingTime';
  static String closingTime = 'closingTime';
  static String deliveryBoy = 'deliveryBoy';
  static String rating = 'rating';
  static String banners = 'banners';
  static String isFirebaseTokenUploaded = 'isFirebaseTokenUploaded';
  static String createdAt = 'createdAt';

  SharedPreferencesManager._();
  static Future<SharedPreferences> getInstance() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      return _sharedPreferences;
    }
    return _sharedPreferences;
  }
}

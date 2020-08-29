import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorModel {
  int _id;
  int _vendorType;
  String _imageUrl;
  String _name;
  String _shopName;
  String _email;
  String _phone;
  String _address;
  bool _isVerified;
  String _city;
  bool _shopOpen;
  bool _optForDeliveryBoy;
  bool _localStore;
  String _upiId;
  String _paytmNo;
  bool _membershipActive;
  String _openingTime;
  String _closingTime;
  int _deliveryBoy;
  String _authorisationToken;
  int _noOfRatings;
  double _rating;
  List<int> _ratingStars;

  VendorModel.fromJson(Map<String, dynamic> parsedJson) {
    _authorisationToken = parsedJson['token'];
    parsedJson = parsedJson['vendor'];
    _id = parsedJson['id'];
    _isVerified = parsedJson['verified'];
    _vendorType = parsedJson['vendor_type'];
    _imageUrl = parsedJson['image_url'];
    _name = parsedJson['name'];
    _address = parsedJson['address'];
    _city = parsedJson['city'];
    _shopOpen = parsedJson['shop_open'];
    _optForDeliveryBoy = parsedJson['opt_for_delivery_boy'];
    _localStore = parsedJson['local_store'];
    _upiId = parsedJson['upi_id'];
    _paytmNo = parsedJson['paytm_no'];
    _membershipActive = parsedJson['membership_active'];
    _openingTime = parsedJson['opening_time'];
    _closingTime = parsedJson['closing_time'];
    _deliveryBoy = parsedJson['delivery_boy'];
    storeInSharedPreferences();
  }

  void storeInSharedPreferences() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    sharedPreferences.setInt(SharedPreferencesManager.id, _id);
    sharedPreferences.setInt(SharedPreferencesManager.vendorType, _vendorType);
    sharedPreferences.setString(SharedPreferencesManager.imageUrl, _imageUrl);
    sharedPreferences.setString(SharedPreferencesManager.name, _name);
    sharedPreferences.setString(SharedPreferencesManager.shopName, _shopName);
    sharedPreferences.setString(SharedPreferencesManager.email, _email);
    sharedPreferences.setString(SharedPreferencesManager.phone, _phone);
    sharedPreferences.setString(SharedPreferencesManager.address, _address);
    sharedPreferences.setString(SharedPreferencesManager.city, _city);
    sharedPreferences.setBool(SharedPreferencesManager.shopOpen, _shopOpen);
    sharedPreferences.setBool(
        SharedPreferencesManager.optForDeliveryBoy, _optForDeliveryBoy);
    sharedPreferences.setBool(SharedPreferencesManager.localStore, _localStore);
    sharedPreferences.setString(SharedPreferencesManager.upiId, _upiId);
    sharedPreferences.setString(SharedPreferencesManager.paytmNo, _paytmNo);
    sharedPreferences.setBool(
        SharedPreferencesManager.membershipActive, _membershipActive);
    sharedPreferences.setString(
        SharedPreferencesManager.openingTime, _openingTime);
    sharedPreferences.setString(
        SharedPreferencesManager.closingTime, _closingTime);
    sharedPreferences.setInt(
        SharedPreferencesManager.deliveryBoy, _deliveryBoy);
    sharedPreferences.setString(
        SharedPreferencesManager.authorisationToken, _authorisationToken);
    sharedPreferences.setBool(SharedPreferencesManager.isLoggedIn, true);
    sharedPreferences.setBool(SharedPreferencesManager.isVerified, _isVerified);
  }

  bool get isVerified => _isVerified;
}

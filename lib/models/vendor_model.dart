import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorModel {
  int id;
  int vendorType;
  String imageUrl;
  String name;
  String shopName;
  String email;
  String phone;
  String address;
  bool isVerified;
  String city;
  bool shopOpen;
  bool optForDeliveryBoy;
  bool localStore;
  String upiId;
  String paytmNo;
  bool membershipActive;
  String openingTime;
  String closingTime;
  int deliveryBoy;
  String authorisationToken;
  double rating;

  VendorModel.fromJson(Map<String, dynamic> parsedJson) {
    authorisationToken = parsedJson['token'];
    parsedJson = parsedJson['vendor'];
    id = parsedJson['id'];
    shopName = parsedJson['shop_name'];
    isVerified = parsedJson['verified'];
    vendorType = parsedJson['vendor_type'];
    imageUrl = parsedJson['image_url'];
    name = parsedJson['name'];
    email = parsedJson['email'];
    phone = parsedJson['phone'];
    address = parsedJson['address'];
    city = parsedJson['city'];
    shopOpen = parsedJson['shop_open'];
    optForDeliveryBoy = parsedJson['opt_for_delivery_boy'];
    localStore = parsedJson['local_store'];
    upiId = parsedJson['upi_id'];
    paytmNo = parsedJson['paytm_no'];
    membershipActive = parsedJson['membership_active'];
    openingTime = parsedJson['opening_time'];
    closingTime = parsedJson['closing_time'];
    deliveryBoy = parsedJson['delivery_boy'];
    rating = parsedJson['rating'];
  }

  VendorModel();

  void storeInSharedPreferences() async {
    SharedPreferences sharedPreferences =
        await SharedPreferencesManager.getInstance();
    sharedPreferences.setInt(SharedPreferencesManager.id, id);
    sharedPreferences.setInt(SharedPreferencesManager.vendorType, vendorType);
    sharedPreferences.setString(SharedPreferencesManager.imageUrl, imageUrl);
    sharedPreferences.setString(SharedPreferencesManager.name, name);
    sharedPreferences.setString(SharedPreferencesManager.shopName, shopName);
    sharedPreferences.setString(SharedPreferencesManager.email, email);
    sharedPreferences.setString(SharedPreferencesManager.phone, phone);
    sharedPreferences.setString(SharedPreferencesManager.address, address);
    sharedPreferences.setString(SharedPreferencesManager.city, city);
    sharedPreferences.setBool(SharedPreferencesManager.shopOpen, shopOpen);
    sharedPreferences.setBool(
        SharedPreferencesManager.optForDeliveryBoy, optForDeliveryBoy);
    sharedPreferences.setBool(SharedPreferencesManager.localStore, localStore);
    sharedPreferences.setString(SharedPreferencesManager.upiId, upiId);
    sharedPreferences.setString(SharedPreferencesManager.paytmNo, paytmNo);
    sharedPreferences.setBool(
        SharedPreferencesManager.membershipActive, membershipActive);
    sharedPreferences.setString(
        SharedPreferencesManager.openingTime, openingTime);
    sharedPreferences.setString(
        SharedPreferencesManager.closingTime, closingTime);
    sharedPreferences.setInt(SharedPreferencesManager.deliveryBoy, deliveryBoy);
    sharedPreferences.setString(
        SharedPreferencesManager.authorisationToken, authorisationToken);
    sharedPreferences.setDouble(SharedPreferencesManager.rating, rating);
    sharedPreferences.setBool(SharedPreferencesManager.isLoggedIn, true);
    sharedPreferences.setBool(SharedPreferencesManager.isVerified, isVerified);
  }

  void getStoredData(SharedPreferences sharedPreferences) async {
    vendorModelGlobal.id =
        sharedPreferences.getInt(SharedPreferencesManager.id);
    vendorModelGlobal.vendorType =
        sharedPreferences.getInt(SharedPreferencesManager.vendorType);
    vendorModelGlobal.imageUrl =
        sharedPreferences.getString(SharedPreferencesManager.imageUrl);
    vendorModelGlobal.name =
        sharedPreferences.getString(SharedPreferencesManager.name);
    vendorModelGlobal.shopName =
        sharedPreferences.getString(SharedPreferencesManager.shopName);
    vendorModelGlobal.email =
        sharedPreferences.getString(SharedPreferencesManager.email);
    vendorModelGlobal.phone =
        sharedPreferences.getString(SharedPreferencesManager.phone);
    vendorModelGlobal.address =
        sharedPreferences.getString(SharedPreferencesManager.address);
    vendorModelGlobal.city =
        sharedPreferences.getString(SharedPreferencesManager.city);
    vendorModelGlobal.shopOpen =
        sharedPreferences.getBool(SharedPreferencesManager.shopOpen);
    vendorModelGlobal.optForDeliveryBoy =
        sharedPreferences.getBool(SharedPreferencesManager.optForDeliveryBoy);
    vendorModelGlobal.localStore =
        sharedPreferences.getBool(SharedPreferencesManager.localStore);
    vendorModelGlobal.upiId =
        sharedPreferences.getString(SharedPreferencesManager.upiId);
    vendorModelGlobal.paytmNo =
        sharedPreferences.getString(SharedPreferencesManager.paytmNo);
    vendorModelGlobal.membershipActive =
        sharedPreferences.getBool(SharedPreferencesManager.membershipActive);
    vendorModelGlobal.openingTime =
        sharedPreferences.getString(SharedPreferencesManager.openingTime);
    vendorModelGlobal.closingTime =
        sharedPreferences.getString(SharedPreferencesManager.closingTime);
    vendorModelGlobal.deliveryBoy =
        sharedPreferences.getInt(SharedPreferencesManager.deliveryBoy);
    vendorModelGlobal.authorisationToken = sharedPreferences
        .getString(SharedPreferencesManager.authorisationToken);
    vendorModelGlobal.rating =
        sharedPreferences.getDouble(SharedPreferencesManager.rating);
  }
}

VendorModel vendorModelGlobal = VendorModel();

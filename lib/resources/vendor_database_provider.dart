import 'dart:async';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:sqflite/sqflite.dart';

class VendorDatabaseProvider {
  Database db;
  final String dbName = 'next_door.db';

  final String columnId = '_id';
  final String mapId = 'product_id';
  final String mapName = 'name';
  final String mapParentId = 'parent_id';
  final String mapTags = 'tags';
  final String mapQuantityByWeight = 'quantity_by_weight';
  final String mapQuantityByPiece = 'quantity_by_piece';
  final String mapImageUrl = 'image_url';
  final String mapHaveColorVariants = 'have_color_variants';
  final String mapHaveSizeVariants = 'have_size_variants';
  final String mapNoOfPhotos = 'no_of_photos';
  final String mapBrand = 'brand';
  final String mapDescription = 'description';
  final String mapStandardQuantitySelling = 'standard_quantity_selling';
  final String mapMrp = 'mrp';
  final String mapImages = 'images';
  final String mapDiscountPercentage = 'discount_percentage';
  final String mapInStock = 'in_stock';
  final String mapViews = 'views';
  final String mapUnitsSold = 'units_sold';
  final String mapNoOfRatings = 'no_of_ratings';
  final String mapTemplateUsed = 'template_used';
  final String mapIsPrimary = 'is_primary';
  final String mapSizeVariants = 'size_variants';
  final String mapColorVariants = 'color_variants';
  final String mapProductCategoryId = 'product_category_id';
  final String mapOrderId = 'order_id';
  final String mapPaid = 'paid';
  final String mapAmount = 'amount';
  final String mapAmountPaidByWallet = 'amount_paid_by_wallet';
  final String mapAmountDue = 'amount_due';
  final String mapDiscountApplied = 'discount_applied';
  final String mapCouponApplied = 'coupon_applied';
  final String mapCouponId = 'coupon_id';
  final String mapCouponDiscount = 'coupon_discount';
  final String mapPaymentMethod = 'payment_method';
  final String mapCashback = 'cashback';
  final String mapUnits = 'units';
  final String mapTransactionId = 'transaction_id';
  final String mapInstructions = 'instructions';
  final String mapStatus = 'status';
  final String mapCancelled = 'cancelled';
  final String mapReview = 'review';
  final String mapRating = 'rating';
  final String mapAddress = 'address';
  final String mapPackedAt = 'packed_at';
  final String mapShippedAt = 'shipped_at';
  final String mapCreatedAt = 'createdAt';
  final String mapDeliveredAt = 'delivered_at';
  final String mapExpectedDeliveryAt = 'expected_delivery_at';
  final String mapProducts = 'products';
  final String mapTitle = 'title';
  final String mapBody = 'body';
  final String mapReceivedAt = 'received_at';

  final String productCategoryTable = 'product_category';
  final String orderTable = 'orders';
  final String notificationTable = 'notification';

  Future open() async {
    var databasesPath = await getDatabasesPath();
    var path = '$databasesPath/$dbName';
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
//      await db.execute(
//          'create table $orderTable ($columnId integer primary key autoincrement, $mapOrderId integer not null, $mapPaid integer not null, '
//          '$mapAmount real not null, $mapAmountPaidByWallet real, $mapAmountDue real not null, $mapDiscountApplied real, $mapCouponApplied integer not null,'
//          '$mapCouponId integer, $mapCouponDiscount real, $mapPaymentMethod text not null, $mapCashback real, $mapUnits integer not null,'
//          '$mapTransactionId text, $mapInstructions text, $mapStatus text not null, $mapCancelled integer not null, $mapReview text, '
//          '$mapRating real, $mapAddress text not null, $mapPackedAt text, $mapShippedAt text, $mapCreatedAt text not null, $mapDeliveredAt text,'
//          '$mapExpectedDeliveryAt text, $mapProducts text not null)');
      await db.execute(

          ///TODO change mapId to mapProductCategoryId
          'create table $productCategoryTable ($columnId integer primary key autoincrement, $mapId integer not null,'
          ' $mapName text not null,$mapParentId integer not null, $mapTags text not null, $mapQuantityByWeight integer not null, '
          '$mapQuantityByPiece integer not null, $mapImageUrl text, $mapHaveColorVariants integer not null, '
          '$mapHaveSizeVariants integer not null, $mapNoOfPhotos integer not null )');

      await db.execute(
          'create table $notificationTable ($columnId integer primary key autoincrement, $mapTitle text not null, $mapBody text not null, $mapReceivedAt text not null)');
    });
  }

  initiateNotification() async {
    if (db == null) {
      await open();
    }
    await db.execute('drop table if exists $notificationTable');
    await db.execute(
        'create table $notificationTable ($columnId integer primary key autoincrement, $mapTitle text not null, $mapBody text not null, $mapReceivedAt text not null)');
  }

  initiateOrder() async {
    if (db == null) {
      await open();
    }
    await db.execute('drop table if exists $orderTable');
    await db.execute(
        'create table $orderTable ($columnId integer primary key autoincrement)');
  }

  Future<ProductCategoryModel> getProductCategory(int id) async {
    if (db == null) {
      await open();
    }
    List<Map> map = await db
        .query(productCategoryTable, where: '$mapId = ?', whereArgs: [id]);
    ProductCategoryModel productCategoryModel =
        ProductCategoryModel.fromMap(map.first);
    print(map.first);
    return productCategoryModel;
  }

  Future<ProductCategoryModel> insertProductCategory(
      ProductCategoryModel productCategoryModel) async {
    if (db == null) {
      await open();
    }
    productCategoryModel.id =
        await db.insert(productCategoryTable, productCategoryModel.toMap());
    return productCategoryModel;
  }

  Future<bool> insertProductCategories(
      List<ProductCategoryModel> productCategoryModelList) async {
    if (db == null) {
      await open();
    }
    await db.rawQuery('DROP table if exists $productCategoryTable');
    await db.execute(

        ///TODO change mapId to mapProductCategoryId
        'create table $productCategoryTable ($columnId integer primary key autoincrement, $mapId integer not null,'
        ' $mapName text not null,$mapParentId integer not null, $mapTags text not null, $mapQuantityByWeight integer not null, '
        '$mapQuantityByPiece integer not null, $mapImageUrl text, $mapHaveColorVariants integer not null, '
        '$mapHaveSizeVariants integer not null, $mapNoOfPhotos integer not null )');
    for (ProductCategoryModel productCategoryModel
        in productCategoryModelList) {
      await db.insert(productCategoryTable, productCategoryModel.toMap());
    }
    return true;
  }

  Future<List<ProductCategoryModel>> getProductCategoriesParentId(
      int parentId) async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db.query(productCategoryTable,
        columns: [
          columnId,
          mapId,
          mapName,
          mapParentId,
          mapTags,
          mapQuantityByWeight,
          mapQuantityByPiece,
          mapImageUrl,
          mapHaveColorVariants,
          mapHaveSizeVariants,
          mapNoOfPhotos
        ],
        where: '$mapParentId = ?',
        whereArgs: [parentId]);
    List<ProductCategoryModel> productCategoryModelList =
        List<ProductCategoryModel>();
    for (var map in maps) {
      productCategoryModelList.add(ProductCategoryModel.fromMap(map));
    }
    return productCategoryModelList;
  }

  Future<int> truncateProductCategory() async {
    return await db.delete(productCategoryTable);
  }

  Future<int> deleteProductCategory(int id) async {
    return await db
        .delete(productCategoryTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<NotificationModel> insertNotification(
      NotificationModel notificationModel) async {
    if (db == null) {
      await open();
    }
    notificationModel.id =
        await db.insert(notificationTable, notificationModel.toMap());
    return notificationModel;
  }

  Future<List<NotificationModel>> getNotifications() async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db.query(notificationTable);
    List<NotificationModel> notificationModelList = List<NotificationModel>();
    for (var map in maps) {
      notificationModelList.add(NotificationModel.fromMap(map));
    }
    print(notificationModelList.toString());
    return notificationModelList;
  }

  Future close() async => db.close();
}

import 'package:sqflite/sqflite.dart';

const String mapId = 'product_id';
const String mapName = 'name';
const String mapParentId = 'parent_id';
const String mapTags = 'tags';
const String mapQuantityByWeight = 'quantity_by_weight';
const String mapQuantityByPiece = 'quantity_by_piece';
const String mapImageUrl = 'image_url';
const String mapHaveColorVariants = 'have_color_variants';
const String mapHaveSizeVariants = 'have_size_variants';
const String mapNoOfPhotos = 'no_of_photos';
const String productCategoryTable = 'product_category';
const String columnId = '_id';
const String CREATE_DB_TABLE =
    'create table $productCategoryTable ($columnId integer primary key autoincrement, $mapId integer not null,'
    ' $mapName text not null,$mapParentId integer not null, $mapTags text not null, $mapQuantityByWeight integer not null, '
    '$mapQuantityByPiece integer not null, $mapImageUrl text not null, $mapHaveColorVariants integer not null, '
    '$mapHaveSizeVariants integer not null, $mapNoOfPhotos integer not null )';
const String dbName = 'next_door.db';

class ProductCategoryModel {
  int id;
  int productId;
  String name;
  int parentId;
  String tags;
  bool quantityByWeight;
  bool quantityByPiece;
  String imageUrl;
  bool haveColorVariants;
  bool haveSizeVariants;
  int noOfPhotos;

  ProductCategoryModel(
    this.id,
    this.productId,
    this.name,
    this.parentId,
    this.tags,
    this.quantityByWeight,
    this.quantityByPiece,
    this.imageUrl,
    this.haveColorVariants,
    this.haveSizeVariants,
    this.noOfPhotos,
  );

  ProductCategoryModel.fromJson(Map<String, dynamic> parsedJson) {
    productId = parsedJson[mapId];
    name = parsedJson[mapName];
    parentId = parsedJson[mapParentId];
    tags = parsedJson[mapTags];
    quantityByWeight = parsedJson[mapQuantityByWeight];
    quantityByPiece = parsedJson[mapQuantityByPiece];
    imageUrl = parsedJson[mapImageUrl];
    haveColorVariants = parsedJson[mapHaveColorVariants];
    haveSizeVariants = parsedJson[mapHaveSizeVariants];
    noOfPhotos = parsedJson[mapNoOfPhotos];
  }

  ProductCategoryModel.fromMap(Map<String, dynamic> parsedJson) {
    productId = parsedJson[mapId];
    name = parsedJson[mapName];
    parentId = parsedJson[mapParentId];
    tags = parsedJson[mapTags];
    quantityByWeight = parsedJson[mapQuantityByWeight] == 1 ? true : false;
    quantityByPiece = parsedJson[mapQuantityByPiece] == 1 ? true : false;
    imageUrl = parsedJson[mapImageUrl];
    haveColorVariants = parsedJson[mapHaveColorVariants] == 1 ? true : false;
    haveSizeVariants = parsedJson[mapHaveSizeVariants] == 1 ? true : false;
    noOfPhotos = parsedJson[mapNoOfPhotos];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mapId: productId,
      mapName: name,
      mapParentId: parentId,
      mapTags: tags,
      mapQuantityByWeight: quantityByWeight ? 1 : 0,
      mapQuantityByPiece: quantityByPiece ? 1 : 0,
      mapImageUrl: imageUrl,
      mapHaveColorVariants: haveColorVariants ? 1 : 0,
      mapHaveSizeVariants: haveSizeVariants ? 1 : 0,
      mapNoOfPhotos: noOfPhotos
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class ProductCategoryProvider {
  Database db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    var path = '$databasesPath/$dbName';
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(CREATE_DB_TABLE);
    });
  }

  Future<ProductCategoryModel> insert(
      ProductCategoryModel productCategoryModel) async {
    productCategoryModel.id =
        await db.insert(productCategoryTable, productCategoryModel.toMap());
    return productCategoryModel;
  }

  Future<ProductCategoryModel> getProductCategory(int id) async {
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
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ProductCategoryModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ProductCategoryModel>> getProductCategoriesParentId(
      int parentId) async {
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

  Future<int> truncate() async {
    return await db.delete(productCategoryTable);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(productCategoryTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}

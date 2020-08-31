class ProductCategoryModel {
  int id;
  int productCategoryId;
  String name;
  int parentId;
  String tags;
  bool quantityByWeight;
  bool quantityByPiece;
  String imageUrl;
  bool haveColorVariants;
  bool haveSizeVariants;
  int noOfPhotos;
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
  final String columnId = '_id';

  ProductCategoryModel(
    this.id,
    this.productCategoryId,
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
    productCategoryId = parsedJson['id'];
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
    productCategoryId = parsedJson[mapId];
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
      mapId: productCategoryId,
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

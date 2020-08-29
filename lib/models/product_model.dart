import 'dart:convert';

class ProductModel {
  int id;
  int productId;
  String name;
  int productCategoryId;
  String brand;
  String description;
  double standardQuantityOfSelling;
  double mrp;
  List<Images> images;
  int discountPercentage;
  bool inStock;
  String tags;
  int views;
  int unitsSold;
  int noOfRatings;
  bool templateUsed;
  bool isPrimary;
  bool inSync;
  List<SizeVariant> sizeVariants;
  List<ColorVariant> colorVariants;
  List<int> relatedProducts;
  final String mapId = 'product_id';
  final String mapName = 'name';
  final String mapBrand = 'brand';
  final String mapDescription = 'description';
  final String mapStandardQuantitySelling = 'standard_quantity_selling';
  final String mapMrp = 'mrp';
  final String mapImages = 'images';
  final String mapDiscountPercentage = 'discount_percentage';
  final String mapInStock = 'in_stock';
  final String mapTags = 'tags';
  final String mapViews = 'views';
  final String mapUnitsSold = 'units_sold';
  final String mapNoOfRatings = 'no_of_ratings';
  final String mapTemplateUsed = 'template_used';
  final String mapIsPrimary = 'is_primary';
  final String mapSizeVariants = 'size_variants';
  final String mapColorVariants = 'color_variants';
  final String mapProductCategoryId = 'product_category_id';
  final String mapInSync = 'in_sync';
  final String columnId = '_id';

  ProductModel(
      this.id,
      this.productId,
      this.name,
      this.productCategoryId,
      this.brand,
      this.description,
      this.standardQuantityOfSelling,
      this.mrp,
      this.discountPercentage,
      this.inStock,
      this.tags,
      this.views,
      this.unitsSold,
      this.noOfRatings,
      this.templateUsed,
      this.isPrimary,
      this.inSync,
      this.sizeVariants,
      this.colorVariants,
      this.relatedProducts);

  ProductModel.fromMap(Map<String, dynamic> parsedJson) {
    productId = parsedJson[mapId];
    name = parsedJson[mapName];
    brand = parsedJson[mapBrand];
    productCategoryId = parsedJson[mapProductCategoryId];
    description = parsedJson[mapDescription];
    standardQuantityOfSelling = parsedJson[mapStandardQuantitySelling];
    mrp = parsedJson[mapMrp];
    images = mapToImages(parsedJson[mapImages]);
    discountPercentage = parsedJson[mapDiscountPercentage];
    inStock = parsedJson[mapInStock] == 1 ? true : false;
    tags = parsedJson[mapTags];
    views = parsedJson[mapViews];
    unitsSold = parsedJson[mapUnitsSold];
    noOfRatings = parsedJson[mapNoOfRatings];
    templateUsed = parsedJson[mapTemplateUsed] == 1 ? true : false;
    isPrimary = parsedJson[mapIsPrimary] == 1 ? true : false;
    List<SizeVariant> tempSizeVariants = List<SizeVariant>();
//    for (var i in parsedJson[mapSizeVariants]) {
//      tempSizeVariants.add(SizeVariant.fromJson(i));
//    }
    sizeVariants = tempSizeVariants;
    List<ColorVariant> tempColorVariants = List<ColorVariant>();
//    for (var i in parsedJson[mapColorVariants]) {
//      tempColorVariants.add(ColorVariant.fromJson(i));
//    }
    colorVariants = tempColorVariants;
  }

  parseImages(dynamic tempImages) {
    List<Images> temp = List<Images>();
    for (var image in tempImages) {
      temp.add(Images.fromJson(image));
    }
    images = temp;
  }

  String imagesToMap() {
    String temp = '';
    for (Images image in images) {
      temp = temp + image.imageUrl + '|';
    }
    return temp.substring(0, temp.length - 1);
  }

  List<Images> mapToImages(String imagesString) {
    List<String> temp = imagesString.split('|');
    List<Images> tempImages = List<Images>();
    for (String i in temp) {
      tempImages.add(Images(i));
    }
    return tempImages;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      mapId: productId,
      mapName: name,
      mapBrand: brand,
      mapDescription: description,
      mapProductCategoryId: productCategoryId,
      mapStandardQuantitySelling: standardQuantityOfSelling,
      mapMrp: mrp,
      mapImages: imagesToMap(),
      mapDiscountPercentage: discountPercentage,
      mapInStock: inStock ? 1 : 0,
      mapTags: tags,
      mapViews: views,
      mapUnitsSold: unitsSold,
      mapNoOfRatings: noOfRatings,
      mapTemplateUsed: templateUsed ? 1 : 0,
      mapIsPrimary: isPrimary ? 1 : 0,
      mapSizeVariants: sizeVariants.toString(),
      mapColorVariants: colorVariants.toString()
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class Images {
  String imageUrl;
  final String mapImageUrl = 'image_url';
  Images.fromJson(Map<String, dynamic> parsedJson) {
    imageUrl = parsedJson[mapImageUrl];
  }

  Images(String image) {
    imageUrl = image;
  }
}

class SizeVariant {
  String size;
  double mrp;
  int discountPercentage;
  final String mapSize = 'size';
  final String mapMrp = 'mrp';
  final String mapDiscountPercentage = 'discount_percentage';
  SizeVariant.fromJson(Map<String, dynamic> parsedJson) {
    size = parsedJson[mapSize];
    mrp = parsedJson[mapMrp];
    discountPercentage = parsedJson[mapDiscountPercentage];
  }
}

class ColorVariant {
  int productId;
  String value;
  final String mapProductId = 'product_id';
  final String mapValue = 'value';
  ColorVariant.fromJson(Map<String, dynamic> parsedJson) {
    productId = parsedJson[mapProductId];
    value = parsedJson[mapValue];
  }
}

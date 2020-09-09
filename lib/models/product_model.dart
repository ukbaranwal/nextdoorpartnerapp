import 'dart:convert';

class ProductModel {
  int id;
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
  final String mapId = 'id';
  final String mapImageUrl = 'image_url';

  ProductModel(
      this.id,
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

  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson[mapId];
    name = parsedJson[mapName];
    brand = parsedJson[mapBrand];
    productCategoryId = parsedJson[mapProductCategoryId];
    description = parsedJson[mapDescription];
    standardQuantityOfSelling =
        convertIntToDouble(parsedJson[mapStandardQuantitySelling]);
    mrp = convertIntToDouble(parsedJson[mapMrp]);
    images = List<Images>();
    for (var i in parsedJson[mapImages]) {
      images.add(Images(i[mapImageUrl]));
    }
    discountPercentage = parsedJson[mapDiscountPercentage];
    inStock = parsedJson[mapInStock];
    tags = parsedJson[mapTags];
    views = parsedJson[mapViews];
    unitsSold = parsedJson[mapUnitsSold];
    noOfRatings = parsedJson[mapNoOfRatings];
    templateUsed = parsedJson[mapTemplateUsed];
    isPrimary = parsedJson[mapIsPrimary];
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

  double convertIntToDouble(int value) {
    if (value == null) {
      return 0.0;
    }
    return double.parse(value.toString());
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

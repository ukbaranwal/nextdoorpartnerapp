import 'dart:convert';

class ProductTemplateModel {
  int id;
  String name;
  int productCategoryId;
  String brand;
  String description;
  double standardQuantityOfSelling;
  double mrp;
  List<Images> images;
  String tags;
  final String mapName = 'name';
  final String mapBrand = 'brand';
  final String mapDescription = 'description';
  final String mapStandardQuantitySelling = 'standard_quantity_selling';
  final String mapMrp = 'mrp';
  final String mapImages = 'images';
  final String mapTags = 'tags';
  final String mapProductCategoryId = 'product_category_id';
  final String mapId = 'id';
  final String mapImageUrl = 'image_url';

  ProductTemplateModel(
      this.id,
      this.name,
      this.productCategoryId,
      this.brand,
      this.description,
      this.standardQuantityOfSelling,
      this.mrp,
      this.images,
      this.tags);

  ProductTemplateModel.fromJson(Map<String, dynamic> parsedJson) {
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
    tags = parsedJson[mapTags];
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

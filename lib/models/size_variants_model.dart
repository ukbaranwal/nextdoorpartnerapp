class SizeVariantModel {
  String sizeLabel;
  String sizeValue;
  SizeVariantModel.fromJson(Map<String, dynamic> parsedJson) {
    sizeLabel = parsedJson['size_label'];
    sizeValue = parsedJson['size_value'];
  }
}

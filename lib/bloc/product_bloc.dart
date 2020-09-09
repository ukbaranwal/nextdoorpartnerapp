import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc implements BlocInterface {
  final _repository = Repository();
  var _productFetcher = PublishSubject<ApiResponse<ProductModel>>();
  Stream<ApiResponse<ProductModel>> get productStream => _productFetcher.stream;

  ProductModel _productModel;
  ProductCategoryModel _productCategoryModel;
  ProductBloc(ProductModel productModel) {
    _productModel = productModel;
  }

  addProduct(ProductModel productModel, List<File> files) async {
    try {
      _productFetcher.sink.add(ApiResponse.loading('Loading', data: {
        'productModel': _productModel,
        'productCategoryModel': _productCategoryModel
      }));
      StreamedResponse streamedResponse =
          await _repository.addProduct(productModel, files);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          _productFetcher.sink.add(ApiResponse.successful(response['message'],
              data: response['data'], showToast: true));
        } else if (streamedResponse.statusCode == 422) {
          _productFetcher.sink
              .add(ApiResponse.validationFailed(response['message']));
        } else {
          _productFetcher.sink.add(ApiResponse.error(response['message']));
        }
      });
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  updateProduct(
      String name,
      String brand,
      String description,
      double standardQuantity,
      double mrp,
      int discount,
      int productCategoryId) async {
    try {
      _productFetcher.sink.add(ApiResponse.loading('Loading', data: {
        'productModel': _productModel,
        'productCategoryModel': _productCategoryModel
      }));
      Response response = await _repository.updateProduct(
          _productModel.id,
          name,
          brand,
          description,
          standardQuantity,
          mrp,
          discount,
          productCategoryId);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _productModel.name = name;
        _productModel.brand = brand;
        _productModel.description = description;
        _productModel.standardQuantityOfSelling = standardQuantity;
        _productModel.mrp = mrp;
        _productModel.discountPercentage = discount;
        _productFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            showToast: true));
      }
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  deleteProductImage(int index) async {
    try {
      Response response = await _repository.deleteProductImage(
          _productModel.id, _productModel.images[index - 1].imageUrl);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _productModel.images.removeAt(index - 1);
        _productFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            showToast: true));
      }
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  addProductImage(File file) async {
    try {
      _productFetcher.sink.add(ApiResponse.loading('Loading', data: {
        'productModel': _productModel,
        'productCategoryModel': _productCategoryModel
      }));
      StreamedResponse streamedResponse =
          await _repository.addProductImage(_productModel.id, file);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          _productModel.images.add(Images(response['data']['image_url']));
          _productFetcher.sink.add(ApiResponse.successful(response['message'],
              data: {
                'productModel': _productModel,
                'productCategoryModel': _productCategoryModel
              },
              showToast: true));
        } else if (streamedResponse.statusCode == 422) {
          _productFetcher.sink
              .add(ApiResponse.validationFailed(response['message']));
        } else {
          _productFetcher.sink.add(ApiResponse.error(response['message']));
        }
      });
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  toggleInStock() async {
    try {
      Response response = await _repository.toggleInStock(
          _productModel.id, !_productModel.inStock);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _productModel.inStock = !_productModel.inStock;
        _productFetcher.sink.add(ApiResponse.successful(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            showToast: true));
      }
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  init(int id) async {
    _productCategoryModel = await _repository.getProductCategory(id);
    _productFetcher.sink.add(ApiResponse.successful('Initiated',
        data: {
          'productModel': _productModel,
          'productCategoryModel': _productCategoryModel
        },
        showToast: false));
  }

  @override
  void dispose() {
    _productFetcher.close();
  }
}

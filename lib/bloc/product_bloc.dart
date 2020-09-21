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
      _productFetcher.sink.add(ApiResponse.hasData('Loading',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      StreamedResponse streamedResponse =
          await _repository.addProduct(productModel, files);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          _productFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: {
                'productModel': _productModel,
                'productCategoryModel': _productCategoryModel
              },
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE));
        } else {
          _productFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: {
                'productModel': _productModel,
                'productCategoryModel': _productCategoryModel
              },
              actions: ApiActions.ERROR,
              loader: LOADER.HIDE));
        }
      });
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
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
      _productFetcher.sink.add(ApiResponse.hasData('Loading',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
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
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _productFetcher.sink
          .add(ApiResponse.error(e.toString(), loader: LOADER.HIDE));
    }
  }

  deleteProductImage(int index) async {
    try {
      _productFetcher.sink.add(ApiResponse.hasData('Loading',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      Response response = await _repository.deleteProductImage(
          _productModel.id, _productModel.images[index - 1].imageUrl);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _productModel.images.removeAt(index - 1);
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
    }
  }

  addProductImage(File file) async {
    try {
      _productFetcher.sink.add(ApiResponse.hasData('Loading',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      StreamedResponse streamedResponse =
          await _repository.addProductImage(_productModel.id, file);
      streamedResponse.stream.listen((value) async {
        dynamic response =
            jsonDecode(await ByteStream.fromBytes(value).bytesToString());
        print(response.toString());
        if (streamedResponse.statusCode == 201) {
          _productModel.images.add(Images(response['data']['image_url']));
          _productFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: {
                'productModel': _productModel,
                'productCategoryModel': _productCategoryModel
              },
              actions: ApiActions.SUCCESSFUL,
              loader: LOADER.HIDE));
        } else {
          _productFetcher.sink.add(ApiResponse.hasData(response['message'],
              data: {
                'productModel': _productModel,
                'productCategoryModel': _productCategoryModel
              },
              actions: ApiActions.ERROR,
              loader: LOADER.HIDE));
        }
      });
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
    }
  }

  toggleInStock() async {
    try {
      _productFetcher.sink.add(ApiResponse.hasData('Loading',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.LOADING,
          loader: LOADER.SHOW));
      Response response = await _repository.toggleInStock(
          _productModel.id, !_productModel.inStock);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _productModel.inStock = !_productModel.inStock;
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.SUCCESSFUL,
            loader: LOADER.HIDE));
      } else {
        _productFetcher.sink.add(ApiResponse.hasData(jsonResponse['message'],
            data: {
              'productModel': _productModel,
              'productCategoryModel': _productCategoryModel
            },
            actions: ApiActions.ERROR,
            loader: LOADER.HIDE));
      }
    } catch (e) {
      _productFetcher.sink.add(ApiResponse.hasData(e.toString(),
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.ERROR,
          loader: LOADER.HIDE));
    }
  }

  init(int id) async {
    _productCategoryModel = await _repository.getProductCategory(id);
    if (_productCategoryModel != null) {
      _productFetcher.sink.add(ApiResponse.hasData('Initiated',
          data: {
            'productModel': _productModel,
            'productCategoryModel': _productCategoryModel
          },
          actions: ApiActions.INITIATED,
          loader: LOADER.IDLE));
    } else {
      _productFetcher.sink.add(ApiResponse.error('Initiated',
          actions: ApiActions.ERROR, loader: LOADER.IDLE));
    }
  }

  @override
  void dispose() {
    _productFetcher.close();
  }
}

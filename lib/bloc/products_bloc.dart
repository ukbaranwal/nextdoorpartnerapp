import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc implements BlocInterface {
  final _repository = Repository();
  var _productsFetcher = PublishSubject<DbResponse<List<ProductModel>>>();
  Stream<DbResponse<List<ProductModel>>> get productsStream =>
      _productsFetcher.stream;

  getProducts() async {
    _productsFetcher = PublishSubject<DbResponse<List<ProductModel>>>();
    try {
      _productsFetcher.sink.add(DbResponse.loading('Checking'));
      List<ProductModel> data = await _repository.getProducts();
      _productsFetcher.sink.add(DbResponse.successful('Done', data: data));
    } catch (e) {
      print(e.toString());
      _productsFetcher.sink.add(DbResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _productsFetcher.close();
  }
}

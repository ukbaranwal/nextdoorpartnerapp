import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nextdoorpartner/bloc/products_bloc.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ProductsBloc productsBloc;
  ScrollController scrollController;
  bool isEnd = false;
  String searchQuery = '';
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2, 4.0),
                  blurRadius: 1.0),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => Products(),
//              ),
//            );
            },
            elevation: 10,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.tune,
              color: AppTheme.secondary_color,
              size: 32,
            ),
          ),
        ),
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductCategory(),
                                ));
                          },
                          child: Text(
                            Strings.addNewProduct,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22),
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search,
                        color: AppTheme.grey,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: searchTextEditingController,
                          cursorColor: AppTheme.secondary_color,
                          onFieldSubmitted: (value) => {},
                          onChanged: (value) {
                            searchQuery = value;
                            productsBloc.getProducts(searchQuery);
                            isEnd = false;
                          },
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondary_color,
                              fontSize: 18),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.grey,
                                  fontSize: 18),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 11, top: 11, right: 10),
                              hintText: Strings.search),
                          onEditingComplete: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.highlight_off,
                            color: AppTheme.grey,
                          ),
                          onPressed: () {
                            if (searchTextEditingController.text.trim() == '') {
                              return;
                            }
                            searchTextEditingController.clear();
                            productsBloc.getProducts('');
                            isEnd = false;
                          },
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                StreamBuilder(
                  stream: productsBloc.productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ApiResponse<List<ProductModel>>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: CircularProgressIndicator(),
                      ));
                    } else {
                      if (snapshot.data.message == 'end' ||
                          snapshot.data.data.length < 6) {
                        isEnd = true;
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        itemCount: snapshot.data.data.length + 1,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          ///Return Single Widget
                          return index == snapshot.data.data.length
                              ? isEnd
                                  ? SizedBox()
                                  : Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                              : ProductWidget(
                                  productModel: snapshot.data.data[index],
                                  index: index + 1);
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productsBloc = ProductsBloc();
    productsBloc.getProducts(searchQuery);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isEnd) {
          productsBloc.getProducts(searchQuery);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    productsBloc.dispose();
    super.dispose();
  }
}

class ProductWidget extends StatelessWidget {
  final ProductModel productModel;
  final int index;

  ProductWidget({this.productModel, this.index});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Product(
                  isNewProduct: false,
                  productModel: productModel,
                  productCategoryId: productModel.productCategoryId,
                )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  child: Image.network(
                    Strings.hostUrl + productModel.images[0].imageUrl,
//                  imageUrl,
                    height: 80,
                    width: 80,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.name,
//                      name,
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    Text(
                      productModel.brand,
//                      brand,
                      style: TextStyle(
                          color: AppTheme.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    Text(
                      'MRP: Rs. ${productModel.mrp}',
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    Text(
                      'Selling: Rs. ${(productModel.mrp - (productModel.mrp * productModel.discountPercentage / 100)).toStringAsFixed(1)}',
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    )
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.background_grey,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Text(
                            productModel.images.length.toString(),
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontWeight: FontWeight.w800,
                                fontSize: 12),
                          ),
                          Icon(
                            Icons.photo,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.background_grey,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Text(
                            productModel.unitsSold.toString(),
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontWeight: FontWeight.w800,
                                fontSize: 12),
                          ),
                          Icon(
                            Icons.shopping_cart,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.background_grey,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Text(
                            productModel.views.toString(),
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontWeight: FontWeight.w800,
                                fontSize: 12),
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            size: 12,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 5,
                      itemSize: 14,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Text(
                          '${productModel.discountPercentage}% off',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                        decoration: BoxDecoration(
                            color: AppTheme.green,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  productModel.inStock ? Strings.inStock : 'Out of Stock',
                  style: TextStyle(
                      fontSize: 14,
                      color: productModel.inStock ? AppTheme.green : Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

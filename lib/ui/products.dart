import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:shimmer/shimmer.dart';

enum ORDER_BY { VIEWS, SOLD, RATING }

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
  ORDER_BY sortedBy;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  void showFilterOption() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setModalState) {
              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sort by',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 24,
                                  color: AppTheme.secondary_color,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: AppTheme.green,
                                groupValue: sortedBy,
                                value: ORDER_BY.SOLD,
                                onChanged: (value) {
                                  setModalState(() {
                                    sortedBy = value;
                                    productsBloc.getProducts(searchQuery,
                                        orderBy: sortedBy);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  sortedBy = ORDER_BY.SOLD;
                                  productsBloc.getProducts(searchQuery,
                                      orderBy: sortedBy);
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Units Sold',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: AppTheme.green,
                                groupValue: sortedBy,
                                value: ORDER_BY.VIEWS,
                                onChanged: (value) {
                                  setModalState(() {
                                    sortedBy = value;
                                    productsBloc.getProducts(searchQuery,
                                        orderBy: sortedBy);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  sortedBy = ORDER_BY.VIEWS;
                                  productsBloc.getProducts(searchQuery,
                                      orderBy: sortedBy);
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Number of Views',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: AppTheme.green,
                                groupValue: sortedBy,
                                value: ORDER_BY.RATING,
                                onChanged: (value) {
                                  setModalState(() {
                                    sortedBy = value;
                                    productsBloc.getProducts(searchQuery,
                                        orderBy: sortedBy);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  sortedBy = ORDER_BY.RATING;
                                  productsBloc.getProducts(searchQuery,
                                      orderBy: sortedBy);
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Rating',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

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
                            productsBloc.getProducts(searchQuery,
                                orderBy: sortedBy);
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
                            productsBloc.getProducts('', orderBy: sortedBy);
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
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      showFilterOption();
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sort by',
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.sort,
                            size: 16,
                            color: AppTheme.secondary_color,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: productsBloc.productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ApiResponse<List<ProductModel>>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
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
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(top: 30),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 35,
                                    ),
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    itemCount: 5,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            height: 84,
                                            decoration: boxDecoration,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  height: 15,
                                                  decoration: boxDecoration,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: 15,
                                                  decoration: boxDecoration,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: 15,
                                                  decoration: boxDecoration,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  height: 15,
                                                  decoration: boxDecoration,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
    productsBloc.getProducts(searchQuery, orderBy: sortedBy);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isEnd) {
          productsBloc.getProducts(searchQuery, orderBy: sortedBy);
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
                  child: CachedNetworkImage(
                    imageUrl: Strings.hostUrl + productModel.images[0].imageUrl,
//                  imageUrl,
                    height: 80,
                    width: 80,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                SizedBox(
                  width: 10,
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
                    productModel.noOfRatings == 0
                        ? SizedBox()
                        : RatingBarIndicator(
                            rating: productModel.rating,
                            itemSize: 14,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                    productModel.discountPercentage != 0
                        ? Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                '${productModel.discountPercentage}% off',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                              decoration: BoxDecoration(
                                  color: AppTheme.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          )
                        : SizedBox()
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

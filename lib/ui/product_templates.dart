import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/product_templates_bloc.dart';
import 'package:nextdoorpartner/bloc/products_bloc.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/product_template_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shimmer/shimmer.dart';

class ProductTemplates extends StatefulWidget {
  final int productCategoryId;

  ProductTemplates(this.productCategoryId);

  @override
  _ProductTemplatesState createState() => _ProductTemplatesState();
}

class _ProductTemplatesState extends State<ProductTemplates> {
  ProductTemplatesBloc productTemplatesBloc;
  ScrollController scrollController;
  bool isEnd = false;
  String searchQuery = '';
  TextEditingController searchTextEditingController = TextEditingController();
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

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
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: productTemplatesBloc.productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ApiResponse<List<ProductTemplateModel>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 10),
                        child: Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 30,
                                ),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                itemCount: 6,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: boxDecoration,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130,
                                            decoration: boxDecoration,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                160,
                                            decoration: boxDecoration,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                190,
                                            decoration: boxDecoration,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
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
                              : ProductTemplateWidget(
                                  productTemplateModel:
                                      snapshot.data.data[index],
                                );
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
    productTemplatesBloc = ProductTemplatesBloc();
    productTemplatesBloc.getProductTemplates(searchQuery);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isEnd) {
          productTemplatesBloc.getProductTemplates(searchQuery);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    productTemplatesBloc.dispose();
    super.dispose();
  }
}

class ProductTemplateWidget extends StatelessWidget {
  final ProductTemplateModel productTemplateModel;

  ProductTemplateWidget({this.productTemplateModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, productTemplateModel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: Strings.hostUrl +
                        productTemplateModel.images[0].imageUrl,
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
                      productTemplateModel.name,
//                      name,
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    Text(
                      productTemplateModel.brand,
//                      brand,
                      style: TextStyle(
                          color: AppTheme.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    Text(
                      'MRP: Rs. ${productTemplateModel.mrp}',
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
                child: SizedBox(
              width: 10,
            )),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                  color: AppTheme.background_grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  Text(
                    productTemplateModel.images.length.toString(),
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
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}

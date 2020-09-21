import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/products_bloc.dart';
import 'package:nextdoorpartner/bloc/review_bloc.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/review_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/data_placeholder.dart';
import 'package:nextdoorpartner/ui/order_page.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shimmer/shimmer.dart';

class Reviews extends StatefulWidget {
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));
  int selected = -1;

  ReviewsBloc reviewsBloc;

  bool isEnd = false;

  final String noOfReviews = 'noOfReviews';
  final String reviewsList = 'reviewsList';

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    reviewsBloc = ReviewsBloc();
    reviewsBloc.getReviews(rating: selected);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isEnd) {
          reviewsBloc.getReviews(rating: selected);
        }
      }
    });
  }

  @override
  void dispose() {
    reviewsBloc.dispose();
    super.dispose();
  }

  filterByRating(int rating) {
    setState(() {
      if (selected == rating) {
        setState(() {
          isEnd = false;
          selected = -1;
        });
      } else {
        setState(() {
          isEnd = false;
          selected = rating;
        });
      }
    });
    reviewsBloc.getReviews(rating: selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          child: StreamBuilder<ApiResponse<List<ReviewModel>>>(
              stream: reviewsBloc.reviewsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<ApiResponse<List<ReviewModel>>> snapshot) {
                print(snapshot);
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: boxDecoration,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          '${snapshot.data.data[noOfReviews]} ${Strings.userReviews}',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RatingWidget(
                              rating: 1,
                              isSelected: selected == 1,
                              callback: filterByRating,
                            ),
                            RatingWidget(
                              rating: 2,
                              isSelected: selected == 2,
                              callback: filterByRating,
                            ),
                            RatingWidget(
                              rating: 3,
                              isSelected: selected == 3,
                              callback: filterByRating,
                            ),
                            RatingWidget(
                              rating: 4,
                              isSelected: selected == 4,
                              callback: filterByRating,
                            ),
                            RatingWidget(
                              rating: 5,
                              isSelected: selected == 5,
                              callback: filterByRating,
                            )
                          ],
                        ),
                      ),
                      snapshot.data.data[reviewsList].length == 0
                          ? NoDataPlaceholderWidget(
                              imageUrl: 'review_placeholder.png',
                              info: Strings.reviewPlaceholder,
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  snapshot.data.data[reviewsList].length + 1,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data.message == 'end' ||
                                    snapshot.data.data[reviewsList].length <
                                        5) {
                                  isEnd = true;
                                }

                                ///Return Single Widget
                                return index ==
                                        snapshot.data.data[reviewsList].length
                                    ? isEnd
                                        ? SizedBox()
                                        : Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                    : ReviewWidget(
                                        boxDecoration: boxDecoration,
                                        orderNo: snapshot.data
                                            .data[reviewsList][index].orderNo,
                                        amount: snapshot.data
                                            .data[reviewsList][index].amount,
                                        deliveredAt: snapshot
                                            .data
                                            .data[reviewsList][index]
                                            .deliveredAt,
                                        units: snapshot.data
                                            .data[reviewsList][index].units,
                                        products: snapshot.data
                                            .data[reviewsList][index].products,
                                        rating: snapshot.data
                                            .data[reviewsList][index].rating,
                                        review: snapshot.data
                                            .data[reviewsList][index].review,
                                        index: index + 1);
                              },
                            ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
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
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 35,
                                ),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                itemCount: 5,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              height: 20,
                                              decoration: boxDecoration,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: 20,
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
                                              height: 25,
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
                                              height: 25,
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
              }),
        ),
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final BoxDecoration boxDecoration;
  final int orderNo;
  final double amount;
  final String deliveredAt;
  final int units;
  final String products;
  final int rating;
  final String review;
  final int index;

  ReviewWidget(
      {this.boxDecoration,
      this.orderNo,
      this.amount,
      this.deliveredAt,
      this.units,
      this.products,
      this.rating,
      this.review,
      this.index});

  Color getColor() {
    if (rating == 1) {
      return AppTheme.rating_1;
    } else if (rating == 2) {
      return AppTheme.rating_2;
    } else if (rating == 3) {
      return AppTheme.rating_3;
    } else if (rating == 4) {
      return AppTheme.rating_4;
    } else {
      return AppTheme.rating_5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: boxDecoration,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${Strings.order} #$orderNo(${Strings.billTotal} Rs. ${amount.round()})',
              style: TextStyle(
                  color: AppTheme.secondary_color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          Text(
              '${Strings.deliveredAt} $deliveredAt | $units ${units == 1 ? 'Item' : 'Items'}',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Strings.items} : ',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              Expanded(
                child: Text(
                  products,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                '${Strings.rating} : ',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              Container(
                decoration: BoxDecoration(
                    color: getColor(),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(rating.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 14,
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '"$review"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => OrderPage(orderNo)));
            },
            child: Text(Strings.viewOrderDetails,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          )
        ],
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final int rating;
  final bool isSelected;
  final Function callback;

  RatingWidget({this.rating, this.isSelected, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        callback(rating);
      },
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.secondary_color : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(rating.toString(),
                style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.secondary_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Icon(
              Icons.star,
              color: isSelected ? Colors.white : AppTheme.secondary_color,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/order_page_bloc.dart';
import 'package:nextdoorpartner/bloc/pending_order_bloc.dart';
import 'package:nextdoorpartner/models/order_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/pending_order.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shimmer/shimmer.dart';

class OrderPage extends StatefulWidget {
  final int orderId;

  OrderPage(this.orderId);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderPageBloc orderPageBloc;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  @override
  void initState() {
    super.initState();
    orderPageBloc = OrderPageBloc();
    orderPageBloc.getOrder(widget.orderId);
    orderPageBloc.orderStream.listen((event) {
      if (event.showToast) {
        CustomToast.show(event.message, context);
      }
    });
  }

  String getStatus(OrderStatus orderStatus) {
    if (orderStatus == OrderStatus.CONFIRMED) {
      return 'CONFIRMED';
    } else if (orderStatus == OrderStatus.DISPATCHED) {
      return 'DISPATCHED';
    } else {
      return 'COMPLETED';
    }
  }

  void showCancelDialog(int index, String imageUrl) {
    Dialog dialog;
    dialog = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: Strings.hostUrl + imageUrl,
          ),
          InkWell(
            onTap: () {
//              bannerBloc.deleteBanner(index);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                'Delete Image',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
    showDialog(context: context, child: dialog);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<ApiResponse<OrderModel>>(
                stream: orderPageBloc.orderStream,
                builder: (BuildContext context,
                    AsyncSnapshot<ApiResponse<OrderModel>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    print(snapshot.data);
                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Order no. ${snapshot.data.data.id}',
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  decoration: BoxDecoration(
//                                          color: AppTheme.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    getStatus(snapshot.data.data.status),
                                    style: TextStyle(
                                        color: AppTheme.green,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total units : ${snapshot.data.data.units}',
                                      style: TextStyle(
                                          color: AppTheme.secondary_color,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                    snapshot.data.data.rating != null
                                        ? RatingBarIndicator(
                                            rating: snapshot.data.data.rating,
                                            itemSize: 20,
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                              'Ordered at ${snapshot.data.data.createdAt}',
                                              style: TextStyle(
                                                  color:
                                                      AppTheme.secondary_color,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          margin: EdgeInsets.only(left: 3),
                                          child: Text(
                                            snapshot.data.data.paid
                                                ? Strings.paid
                                                : 'cod',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          decoration: BoxDecoration(
                                              color: snapshot.data.data.paid
                                                  ? AppTheme.green
                                                  : Colors.yellowAccent,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5))),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                            'Expected delivery before ${snapshot.data.data.expectedDeliveryAt}\nDelivered at Nov 24 2020, 5:00 pm'
                                            'Total amount: ${snapshot.data.data.amount}\nDiscount applied: ${snapshot.data.data.discountApplied}\nAmount due: ${snapshot.data.data.amountDue}',
                                            style: TextStyle(
                                                color: AppTheme.secondary_color,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      padding: const EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: AppTheme.background_grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(
                                          snapshot.data.data.review == null
                                              ? snapshot.data.data.instructions
                                              : snapshot.data.data.review,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.secondary_color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      height: 5,
                                      color: AppTheme.background_grey,
                                    ),
                                    ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Divider(
                                        thickness: 2,
                                        height: 5,
                                        indent: 10,
                                        endIndent: 10,
                                        color: AppTheme.background_grey,
                                      ),
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 2),
                                      itemCount:
                                          snapshot.data.data.products.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        ///Return Single Widget
                                        return PendingOrderProduct(
                                          orderProductModel: snapshot
                                              .data.data.products[index],
                                          checkbox: SizedBox(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
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
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                            0.5 -
                                        25,
                                    height: 40,
                                    decoration: boxDecoration,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height: 84,
                                      decoration: boxDecoration,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 15,
                                  ),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  itemCount: 4,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 15,
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
                                                  150,
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
                                                  170,
                                              decoration: boxDecoration,
                                            ),
                                          ],
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
      ),
    );
  }

  @override
  void dispose() {
    orderPageBloc.dispose();
    super.dispose();
  }
}

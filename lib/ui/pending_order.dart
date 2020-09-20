import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/pending_order_bloc.dart';
import 'package:nextdoorpartner/models/order_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/orders.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shimmer/shimmer.dart';

class PendingOrder extends StatefulWidget {
  final int orderId;

  PendingOrder(this.orderId);

  @override
  _PendingOrderState createState() => _PendingOrderState();
}

class _PendingOrderState extends State<PendingOrder> {
  bool selectedAll = false;
  PendingOrderBloc pendingOrderBloc;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0X00FFFFFF),
      builder: (context) {
        return LoadingDialog();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pendingOrderBloc = PendingOrderBloc();
    pendingOrderBloc.getOrder(widget.orderId);
    pendingOrderBloc.orderStream.listen((event) {
      if (event.loader == LOADER.SHOW) {
        showLoadingDialog();
      } else if (event.loader == LOADER.HIDE) {
        CustomToast.show(event.message, context);
        Navigator.pop(context);
      }
      if (event.actions == ApiActions.SUCCESSFUL) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Orders()));
      }
    });
  }

  void cancelOrder() {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cancel Order',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.background_grey)),
              child: TextFormField(
                controller: textEditingController,
                maxLines: 5,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary_color,
                    fontSize: 16),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  hintText:
                      'Provide a reason for Cancellation, This may affect your ratings and you may be contact by Next Door',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: Color(0xffB9BABC),
                  ),
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  pendingOrderBloc.cancelOrder(
                      widget.orderId, textEditingController.text);
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        bottomNavigationBar: InkWell(
          onTap: () {
            pendingOrderBloc.confirmOrder(widget.orderId);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, -1),
                  color: Colors.black.withOpacity(0.4))
            ], color: AppTheme.green),
            child: Text(
              'Confirm Order',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<ApiResponse<OrderModel>>(
                stream: pendingOrderBloc.orderStream,
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: RaisedButton(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onPressed: () {
                                    cancelOrder();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            )
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
                                child: Text(
                                  'Total units : ${snapshot.data.data.units}',
                                  style: TextStyle(
                                      color: AppTheme.secondary_color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                                'Expected delivery before ${snapshot.data.data.expectedDeliveryAt}\n'
                                                'Total amount: ${snapshot.data.data.amount}\nDiscount applied: ${snapshot.data.data.discountApplied}\nAmount due: ${snapshot.data.data.amountDue}',
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .secondary_color,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text('Select All',
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .secondary_color,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Checkbox(
                                                value: snapshot.data.data
                                                    .allProductSelected,
                                                onChanged: (value) {
                                                  pendingOrderBloc
                                                      .selectAll(value);
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ListView.builder(
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
                                          checkbox: Checkbox(
                                              value: snapshot.data.data
                                                  .products[index].isSelected,
                                              onChanged: (value) {
                                                pendingOrderBloc.select(
                                                    index, value);
                                              }),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
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
    pendingOrderBloc.dispose();
    super.dispose();
  }
}

class PendingOrderProduct extends StatelessWidget {
  final Widget checkbox;
  final OrderProductModel orderProductModel;

  PendingOrderProduct({this.checkbox, this.orderProductModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: CachedNetworkImage(
              imageUrl: Strings.hostUrl + orderProductModel.image,
              width: MediaQuery.of(context).size.width * 0.2,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75 - 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Id: ${orderProductModel.productId}',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        orderProductModel.productName,
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Selling Price : ${orderProductModel.amount}',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Discount Applied : ${orderProductModel.discountApplied}',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Total Price : ${orderProductModel.amount} x ${orderProductModel.quantity} = ${orderProductModel.amount * orderProductModel.quantity}',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text('Quantity : ${orderProductModel.quantity}',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    checkbox
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

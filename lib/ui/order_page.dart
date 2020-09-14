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

class OrderPage extends StatefulWidget {
  final int orderId;

  OrderPage(this.orderId);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderPageBloc orderPageBloc;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        bottomNavigationBar: InkWell(
          onTap: () {},
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: RaisedButton(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onPressed: () {},
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
                                    RatingBarIndicator(
                                      rating: snapshot.data.data.rating,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
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
                                          snapshot.data.data.instructions,
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
                    return Center(
                      child: CircularProgressIndicator(),
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

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/order_bloc.dart';
import 'package:nextdoorpartner/models/order_model.dart';
import 'package:nextdoorpartner/models/order_model_bloc.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  PageController pageController = PageController();
  int pageNo = 0;
  OrderBloc orderBloc;
  final String completed = 'Completed';
  final String dispatched = 'Dispatched';
  final String confirmed = 'Confirmed';
  final String pending = 'Pending';
  @override
  void initState() {
    super.initState();
    orderBloc = OrderBloc();
    orderBloc.getOrders(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          hideShadow: true,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: AppTheme.background_grey,
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 0,
                    label: pending,
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 1,
                    label: confirmed,
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 2,
                    label: dispatched,
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 3,
                    label: completed,
                    currentPage: pageNo,
                  ),
                ],
              ),
            ),
            StreamBuilder<ApiResponse<OrderModelBloc>>(
                stream: orderBloc.ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<ApiResponse<OrderModelBloc>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    print(snapshot);
                    return Expanded(
                      child: PageView(
                        onPageChanged: (page) {
                          setState(() {
                            pageNo = page;
                            orderBloc.getOrders(pageNo, fromPagerView: true);
                          });
                        },
                        controller: pageController,
                        children: [
                          OrdersPageView(
                            orderCount: snapshot.data.data.noOfOrdersPending,
                            orderModelList:
                                snapshot.data.data.ordersModelListPending,
                            isEnd: snapshot
                                    .data.data.ordersModelListPending.length ==
                                snapshot.data.data.noOfOrdersPending,
                            callback: orderBloc.getOrders,
                            pageNo: 0,
                          ),
                          OrdersPageView(
                            orderCount: snapshot.data.data.noOfOrdersConfirmed,
                            orderModelList:
                                snapshot.data.data.ordersModelListConfirmed,
                            isEnd: snapshot.data.data.ordersModelListConfirmed
                                    .length ==
                                snapshot.data.data.noOfOrdersConfirmed,
                            callback: orderBloc.getOrders,
                            pageNo: 1,
                          ),
                          OrdersPageView(
                            orderCount: snapshot.data.data.noOfOrdersDispatched,
                            orderModelList:
                                snapshot.data.data.ordersModelListDispatched,
                            isEnd: snapshot.data.data.ordersModelListDispatched
                                    .length ==
                                snapshot.data.data.noOfOrdersDispatched,
                            callback: orderBloc.getOrders,
                            pageNo: 2,
                          ),
                          OrdersPageView(
                            orderCount: snapshot.data.data.noOfOrdersCompleted,
                            orderModelList:
                                snapshot.data.data.ordersModelListCompleted,
                            isEnd: snapshot.data.data.ordersModelListCompleted
                                    .length ==
                                snapshot.data.data.noOfOrdersCompleted,
                            callback: orderBloc.getOrders,
                            pageNo: 3,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    orderBloc.dispose();
    super.dispose();
  }
}

class OrdersPageView extends StatefulWidget {
  final int orderCount;
  final List<OrderModel> orderModelList;
  final bool isEnd;
  final Function callback;
  final int pageNo;

  OrdersPageView(
      {this.orderCount,
      this.orderModelList,
      this.isEnd,
      this.callback,
      this.pageNo});

  @override
  _OrdersPageViewState createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!widget.isEnd) {
          widget.callback(widget.pageNo);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        color: AppTheme.background_grey,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '${widget.orderCount} orders',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              itemCount: widget.orderModelList.length + 1,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                ///Return Single Widget
                return index == widget.orderModelList.length
                    ? widget.isEnd
                        ? SizedBox()
                        : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            ),
                          )
                    : OrderItemWidget(orderModel: widget.orderModelList[index]);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class OrderItemWidget extends StatelessWidget {
  OrderItemWidget({this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order id : ${orderModel.id}',
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                RatingBarIndicator(
                  rating: 5,
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
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text('Total units : ${orderModel.units}',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        orderModel.paid ? Strings.paid : 'cod',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                          color:
                              orderModel.paid ? AppTheme.green : Colors.yellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                      'Ordered at ${orderModel.createdAt}\nExpected delivery before ${orderModel.expectedDeliveryAt}\n'
                      'Delivered at ${orderModel.deliveredAt}\nTotal amount: ${orderModel.amount}\n'
                      'Discount applied: ${orderModel.discountApplied}\nAmount due:${orderModel.amountDue}',
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppTheme.background_grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(orderModel.instructions,
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tap here for more details',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.secondary_color,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <OrdersProductWidget>[
                      OrdersProductWidget(),
                      OrdersProductWidget(),
                      OrdersProductWidget(),
                      OrdersProductWidget(),
                      OrdersProductWidget(),
                      OrdersProductWidget(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersProductWidget extends StatelessWidget {
  final OrderProductModel orderProductModel;

  OrdersProductWidget({this.orderProductModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maggi x 2',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                Text('Rs. 20',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maggi x 2',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                Text('Rs. 20',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w700))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderPagerTitle extends StatelessWidget {
  final PageController pageController;
  final int pageNo;
  final String label;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pageController.animateToPage(pageNo % 4,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: pageNo == currentPage
                        ? AppTheme.secondary_color
                        : Colors.white,
                    width: 2))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            label,
            style: TextStyle(
                color: AppTheme.secondary_color,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  OrderPagerTitle(
      {this.pageController, this.pageNo, this.label, this.currentPage});
}

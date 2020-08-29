import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 0,
                    label: 'Pending',
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 1,
                    label: 'Confirmed',
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 2,
                    label: 'Dispatched',
                    currentPage: pageNo,
                  ),
                  OrderPagerTitle(
                    pageController: pageController,
                    pageNo: 3,
                    label: 'Completed',
                    currentPage: pageNo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (page) {
                  setState(() {
                    pageNo = page;
                  });
                },
                controller: pageController,
                children: [
                  OrdersPageView(),
                  OrdersPageView(),
                  OrdersPageView(),
                  OrdersPageView()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrdersPageView extends StatelessWidget {
  const OrdersPageView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppTheme.background_grey,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '10 orders',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'order id : 192',
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
                              child: Text('Total units : 2',
                                  style: TextStyle(
                                      color: AppTheme.secondary_color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                Strings.paid,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              decoration: BoxDecoration(
                                  color: AppTheme.green,
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
                              'Ordered at Nov 24 2020, 08:30 am\nExpected delivery before Nov 24 2020, 5:00 pm\n'
                              'Delivered at Nov 24 2020, 5:00 pm\nTotal amount: 40\nDiscount applied: 4\nAmount due: 0',
                              style: TextStyle(
                                  color: AppTheme.secondary_color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.background_grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text('Make Sure to Deliver it by Evening',
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
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersProductWidget extends StatelessWidget {
  const OrdersProductWidget({
    Key key,
  }) : super(key: key);

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

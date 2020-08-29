import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class PendingOrder extends StatefulWidget {
  @override
  _PendingOrderState createState() => _PendingOrderState();
}

class _PendingOrderState extends State<PendingOrder> {
  bool selectedAll = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: Container(
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
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
          ),
        ),
        body: Container(
          color: AppTheme.background_grey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'order no. 192',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total units : 2',
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
                                child: Text('Ordered at Nov 24 2020, 08:30 am',
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                      'Expected delivery before Nov 24 2020, 5:00 pm\n'
                                      'Delivered at Nov 24 2020, 5:00 pm\nTotal amount: 40\nDiscount applied: 4\nAmount due: 0',
                                      style: TextStyle(
                                          color: AppTheme.secondary_color,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text('Select All',
                                        style: TextStyle(
                                            color: AppTheme.secondary_color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Checkbox(
                                      value: selectedAll,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAll = value;
                                        });
                                      }),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          PendingOrderProduct(
                            checkbox: Checkbox(
                                value: selectedAll,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAll = value;
                                  });
                                }),
                          ),
                          PendingOrderProduct(
                            checkbox: Checkbox(
                                value: selectedAll,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAll = value;
                                  });
                                }),
                          ),
                          PendingOrderProduct(
                            checkbox: Checkbox(
                                value: selectedAll,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAll = value;
                                  });
                                }),
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
          ),
        ),
      ),
    );
  }
}

class PendingOrderProduct extends StatelessWidget {
  final Checkbox checkbox;

  PendingOrderProduct({this.checkbox});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image.asset(
              'assets/images/a.jpg',
              width: MediaQuery.of(context).size.width * 0.25,
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
                        'Product Id: 1923',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Maggi',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Selling Price : 12',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Discount Applied : 2',
                        style: TextStyle(
                            color: AppTheme.secondary_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Total Price : 12 x 2 = 24',
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
                    Text('Quantity : 2',
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

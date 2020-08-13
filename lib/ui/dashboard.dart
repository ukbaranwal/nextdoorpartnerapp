import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/models/tabIcon_data.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/bottom_bar_view.dart';
import 'package:nextdoorpartner/ui/products.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: AppTheme.background_grey,
  );

  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  TextStyle textStyleStats = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 22,
      color: AppTheme.secondary_color);

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 80),
        height: 70,
        width: 70,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Products(),
              ),
            );
          },
          elevation: 10,
          backgroundColor: AppTheme.secondary_color,
          child: Transform.rotate(
            child: Icon(
              Icons.notifications_active,
              size: 32,
            ),
            angle: 345,
          ),
        ),
      ),
      backgroundColor: AppTheme.background_grey,
      appBar: CustomAppBar(
        isDashboard: true,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: AppTheme.background_grey,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50 - 15,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                'monthly sales',
                                style: textStyleStats,
                              ),
                              Text('(january 2020)', style: textStyleStats),
                              Text('Rs. 99999', style: textStyleStats)
                            ],
                          ),
                          decoration: boxDecoration,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50 - 15,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Text(
                                'sales today',
                                style: textStyleStats,
                              ),
                              Text('13 jan 2020', style: textStyleStats),
                              Text('Rs. 99999', style: textStyleStats)
                            ],
                          ),
                          decoration: boxDecoration,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  RatingCardDashboard(
                    boxDecoration: boxDecoration,
                    totalRatings: 20,
                    avgRating: 3.6,
                  ),
                  Container(
                    decoration: boxDecoration,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          'recent orders',
                          style: textStyleStats,
                        ),
                        Divider(
                          color: AppTheme.background_grey,
                          thickness: 2,
                          indent: 30,
                          endIndent: 30,
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1974,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: false,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kajhgfdghjfdxcggfghjhgjhjghlyani',
                        ),
                        RecentOrderWidget(
                          orderNo: 1973,
                          orderValue: 1920,
                          units: 10,
                          discount: 200,
                          date: '13/01/2020 13:20',
                          isPaid: true,
                          name: 'Utkarsh Baranwal',
                          address: 'B14/172 Kalyani',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 95,
                  )
                ],
              ),
            ),
          ),
          bottomBar(),
        ],
      ),
    );
  }
}

class RatingCardDashboard extends StatelessWidget {
  final BoxDecoration boxDecoration;
  final double avgRating;
  final int totalRatings;

  RatingCardDashboard({this.boxDecoration, this.avgRating, this.totalRatings});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '$avgRating',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              Text('Average\nRating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar(
                rating: '5',
                color: AppTheme.rating_5,
                noOfRating: 11,
                totalRatings: 20,
              ),
              RatingBar(
                rating: '4',
                color: AppTheme.rating_4,
                noOfRating: 3,
                totalRatings: 20,
              ),
              RatingBar(
                rating: '3',
                color: AppTheme.rating_3,
                noOfRating: 2,
                totalRatings: 20,
              ),
              RatingBar(
                rating: '2',
                color: AppTheme.rating_2,
                noOfRating: 1,
                totalRatings: 20,
              ),
              RatingBar(
                rating: '1',
                color: AppTheme.rating_1,
                noOfRating: 7,
                totalRatings: 20,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '$totalRatings',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              Text('Ratings',
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))
            ],
          ),
        ],
      ),
    );
  }
}

class RecentOrderWidget extends StatelessWidget {
  final int orderNo;
  final double orderValue;
  final int units;
  final double discount;
  final String date;
  final bool isPaid;
  final String name;
  final String address;

  RecentOrderWidget(
      {this.orderNo,
      this.orderValue,
      this.units,
      this.discount,
      this.date,
      this.isPaid,
      this.name,
      this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
      decoration: BoxDecoration(
          color: AppTheme.background_grey,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$orderNo',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary_color),
                ),
                Text(
                  'order value:\nRs. $orderValue',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary_color),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total units: $units',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary_color),
                ),
                Text(
                  'total discount:\nRs. $discount',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary_color),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        isPaid ? 'paid' : 'cod',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                          color: isPaid ? AppTheme.green : Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Tooltip(
                    message: '$name\n$address',
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      '$name\n$address',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final String rating;
  final Color color;
  final int noOfRating;
  final int totalRatings;

  RatingBar({this.rating, this.color, this.noOfRating, this.totalRatings});

  @override
  Widget build(BuildContext context) {
    double widthBar = noOfRating / totalRatings * 0.3;
    return Row(
      children: [
        Text(
          rating,
          style: TextStyle(
              color: AppTheme.secondary_color,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.star,
          size: 16,
          color: AppTheme.secondary_color,
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 16,
          width: MediaQuery.of(context).size.width * widthBar,
          color: color,
        ),
        Container(
          height: 16,
          width: MediaQuery.of(context).size.width * 0.3 -
              MediaQuery.of(context).size.width * widthBar,
          color: AppTheme.rating_0,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '$noOfRating',
          style: TextStyle(
              color: AppTheme.secondary_color,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

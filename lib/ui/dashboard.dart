import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nextdoorpartner/bloc/dashboard_bloc.dart';
import 'package:nextdoorpartner/models/dashboard_model.dart';
import 'package:nextdoorpartner/models/order_model.dart';
import 'package:nextdoorpartner/models/tabIcon_data.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/bottom_bar_view.dart';
import 'package:nextdoorpartner/ui/change_password.dart';
import 'package:nextdoorpartner/ui/coupons.dart';
import 'package:nextdoorpartner/ui/error_screens.dart';
import 'package:nextdoorpartner/ui/help_page.dart';
import 'package:nextdoorpartner/ui/loading_dialog.dart';
import 'package:nextdoorpartner/ui/login.dart';
import 'package:nextdoorpartner/ui/new_order.dart';
import 'package:nextdoorpartner/ui/notifications.dart';
import 'package:nextdoorpartner/ui/order_page.dart';
import 'package:nextdoorpartner/ui/pending_order.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/ui/product_templates.dart';
import 'package:nextdoorpartner/ui/products.dart';
import 'package:nextdoorpartner/ui/seller_support.dart';
import 'package:nextdoorpartner/ui/terms_and_conditions.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/background_sync.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/database.dart';
import 'package:nextdoorpartner/util/date_converter.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'banners.dart';

enum RevenueDuration {
  TODAY,
  YESTERDAY,
  LAST7DAYS,
  MONTH,
  LAST_MONTH,
  LIFETIME
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget tabBody = Container(
    color: AppTheme.background_grey,
  );

  RevenueDuration dropDownValue = RevenueDuration.LIFETIME;

  OrderFilter orderFilter = OrderFilter.ALL;

  DashboardBloc dashboardBloc;

  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));

  TextStyle textStyleStats = TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 18,
      color: AppTheme.secondary_color);

  AnimationController animationController;

  int noOfNotifications = 0;

  bool isDialogLoading = false;

  void filterOrder(OrderFilter orderFilter) {
    this.orderFilter = orderFilter;
    dashboardBloc.filter(orderFilter);
  }

  void signOut() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation Dialog',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            content: Text(
              'Are you sure you want to Sign Out',
              style: TextStyle(
                  color: AppTheme.secondary_color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferencesManager.getInstance();
                  sharedPreferences.clear();
                  CustomToast.show('You have successfully logged out', context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ), (route) => false);
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

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

  void changeShopStatus() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation Dialog',
                style: TextStyle(
                    color: AppTheme.secondary_color,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            content: Text(
              'Are you sure you want to go ${vendorModelGlobal.shopOpen ? 'Offline' : 'Online'}',
              style: TextStyle(
                  color: AppTheme.secondary_color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (await dashboardBloc.changeShopStatus()) {
                    setState(() {
                      vendorModelGlobal.shopOpen = !vendorModelGlobal.shopOpen;
                    });
                  }
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    runIsolate();
    dashboardBloc = DashboardBloc();
    dashboardBloc.getDashboard();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    dashboardBloc.dashboardStream.listen((event) {
      if (event.status == Status.SOCKET_ERROR) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ErrorScreen(
                      errorType: ErrorType.NO_INTERNET,
                    )));
      } else if (event.status == Status.ERROR) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ErrorScreen(
                      errorType: ErrorType.SERVER_ERROR,
                    )));
      }
      if (event.showToast) {
        CustomToast.show(event.message, context);
      }
      if (event.showLoader) {
        showLoadingDialog();
        isDialogLoading = true;
      } else if (!event.showLoader && isDialogLoading) {
        Navigator.pop(context);
      }
    });
    initDb('next_door.db');
  }

  void runIsolate() async {
    BackgroundSync backgroundSync = BackgroundSync();
    await backgroundSync.initializeIsolate(setNoOfNotification);
  }

  void setNoOfNotification(int count) {
    setState(() {
      noOfNotifications = count;
    });
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            print(5);
          },
          scaffoldKey: scaffoldKey,
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
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: Strings.hostUrl + vendorModelGlobal.imageUrl,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendorModelGlobal.shopName,
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                          Text(vendorModelGlobal.address,
                              style: TextStyle(
                                  color: AppTheme.secondary_color,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18)),
                          Text(vendorModelGlobal.email,
                              style: TextStyle(
                                  color: AppTheme.secondary_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          Text(vendorModelGlobal.phone,
                              style: TextStyle(
                                  color: AppTheme.secondary_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    changeShopStatus();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: vendorModelGlobal.shopOpen
                                  ? AppTheme.green
                                  : Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 28,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        vendorModelGlobal.shopOpen ? Strings.online : 'Offline',
                        style: TextStyle(
                            color: vendorModelGlobal.shopOpen
                                ? AppTheme.green
                                : Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: AppTheme.background_grey,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.home,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.products,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.addNewProduct,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.orders,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.payments,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    Strings.accountHealth,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      Strings.help,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellerSupport(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      Strings.sellerSupport,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      Strings.signOut,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary_color),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                        '${Strings.sellingSince}\n${vendorModelGlobal.createdAt}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondary_color)),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
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
                      builder: (context) => Notifications(),
                    ),
                  );
                },
                elevation: 10,
                backgroundColor: AppTheme.secondary_color,
                child: Icon(
                  Icons.notifications_active,
                  size: 32,
                ),
              ),
            ),
            noOfNotifications == 0
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Text(
                      noOfNotifications.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.secondary_color),
                    ),
                  )
          ],
        ),
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: StreamBuilder<ApiResponse<DashboardModel>>(
            stream: dashboardBloc.dashboardStream,
            builder:
                (context, AsyncSnapshot<ApiResponse<DashboardModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.status == Status.HAS_DATA) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          color: AppTheme.background_grey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<RevenueDuration>(
                                      value: snapshot.data.data.revenueDuration,
                                      items: [
                                        DropdownMenuItem(
                                          child: DropDownTextWidget(
                                              Strings.lifeTime),
                                          value: RevenueDuration.LIFETIME,
                                        ),
                                        DropdownMenuItem(
                                          child:
                                              DropDownTextWidget(Strings.today),
                                          value: RevenueDuration.TODAY,
                                        ),
                                        DropdownMenuItem(
                                          child: DropDownTextWidget(
                                              Strings.yesterday),
                                          value: RevenueDuration.YESTERDAY,
                                        ),
                                        DropdownMenuItem(
                                          child: DropDownTextWidget(
                                              Strings.lastWeek),
                                          value: RevenueDuration.LAST7DAYS,
                                        ),
                                        DropdownMenuItem(
                                          child:
                                              DropDownTextWidget('This Month'),
                                          value: RevenueDuration.MONTH,
                                        ),
                                        DropdownMenuItem(
                                          value: RevenueDuration.LAST_MONTH,
                                          child: DropDownTextWidget(
                                              Strings.lastMonth),
                                        )
                                      ],
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onChanged: (value) {
                                        dashboardBloc
                                            .getDashboardRevenue(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.50 -
                                                15,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Strings.orders + ' Completed',
                                              style: textStyleStats,
                                            ),
                                            Text(
                                                snapshot.data.data.noOfOrders
                                                    .toString(),
                                                style: textStyleStats)
                                          ],
                                        ),
                                        decoration: boxDecoration,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductCategory(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.50 -
                                                15,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Strings.revenue,
                                              style: textStyleStats,
                                            ),
                                            Text(
                                                'Rs. ${snapshot.data.data.revenue}',
                                                style: textStyleStats)
                                          ],
                                        ),
                                        decoration: boxDecoration,
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangePassword()));
                                },
                                child: RatingCardDashboard(
                                  boxDecoration: boxDecoration,
                                  totalRatings: snapshot.data.data.noOfRatings,
                                  avgRating: snapshot.data.data.rating,
                                  ratingStars: snapshot.data.data.ratingStars,
                                ),
                              ),
                              Container(
                                decoration: boxDecoration,
                                padding: EdgeInsets.only(top: 10),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewOrder(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              Strings.activeOrders,
                                              style: textStyleStats,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ActiveOrderOptionWidget(
                                                text: 'All',
                                                isSelected: orderFilter ==
                                                    OrderFilter.ALL,
                                                orderFilter: OrderFilter.ALL,
                                                callback: filterOrder,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: ActiveOrderOptionWidget(
                                                  text: 'Pending',
                                                  isSelected: orderFilter ==
                                                      OrderFilter.PENDING,
                                                  orderFilter:
                                                      OrderFilter.PENDING,
                                                  callback: filterOrder,
                                                ),
                                              ),
                                              ActiveOrderOptionWidget(
                                                text: 'Confirmed',
                                                isSelected: orderFilter ==
                                                    OrderFilter.CONFIRMED,
                                                orderFilter:
                                                    OrderFilter.CONFIRMED,
                                                callback: filterOrder,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: AppTheme.background_grey,
                                      thickness: 2,
                                      indent: 30,
                                      endIndent: 30,
                                    ),
                                    ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 2),
                                      itemCount: snapshot
                                          .data.data.orderModelList.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        ///Return Single Widget
                                        return RecentOrderWidget(
                                          orderNo: snapshot.data.data
                                              .orderModelList[index].id,
                                          orderValue: snapshot.data.data
                                              .orderModelList[index].amount,
                                          units: snapshot.data.data
                                              .orderModelList[index].units,
                                          discount: snapshot
                                              .data
                                              .data
                                              .orderModelList[index]
                                              .discountApplied,
                                          date: snapshot.data.data
                                              .orderModelList[index].createdAt,
                                          isPaid: snapshot.data.data
                                              .orderModelList[index].paid,
                                          name: 'Utkarsh',
                                          address: 'B14/172 Kalyani',
                                          orderStatus: snapshot.data.data
                                              .orderModelList[index].status,
                                        );
                                      },
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
                  );
                } else if (snapshot.data.status == Status.SOCKET_ERROR) {
                  return ErrorScreen(
                    errorType: ErrorType.NO_INTERNET,
                  );
                } else {
                  return ErrorScreen(
                    errorType: ErrorType.SERVER_ERROR,
                  );
                }
              } else {
                return Shimmer.fromColors(
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    25,
                                height: 60,
                                decoration: boxDecoration,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    25,
                                height: 60,
                                decoration: boxDecoration,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 20,
                                  decoration: boxDecoration,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height: 20,
                                  decoration: boxDecoration,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 20,
                                  decoration: boxDecoration,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height: 20,
                                  decoration: boxDecoration,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 20,
                                  decoration: boxDecoration,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: 4,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        decoration: boxDecoration,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 25,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                95,
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
                );
              }
            }),
      ),
    );
  }
}

class ActiveOrderOptionWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function callback;
  final OrderFilter orderFilter;

  ActiveOrderOptionWidget(
      {this.text, this.isSelected, this.callback, this.orderFilter});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback(orderFilter);
      },
      child: Container(
          child: Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.secondary_color,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.secondary_color
                  : AppTheme.background_grey,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}

class DropDownTextWidget extends StatelessWidget {
  final String text;

  DropDownTextWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: AppTheme.secondary_color,
          fontWeight: FontWeight.w700,
          fontSize: 14),
    );
  }
}

class RatingCardDashboard extends StatelessWidget {
  final BoxDecoration boxDecoration;
  final double avgRating;
  final int totalRatings;
  final List<int> ratingStars;

  RatingCardDashboard(
      {this.boxDecoration,
      this.avgRating,
      this.totalRatings,
      this.ratingStars});

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
              Text(Strings.averageRating,
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
                noOfRating: ratingStars[4],
                totalRatings: totalRatings,
              ),
              RatingBar(
                rating: '4',
                color: AppTheme.rating_4,
                noOfRating: ratingStars[3],
                totalRatings: totalRatings,
              ),
              RatingBar(
                rating: '3',
                color: AppTheme.rating_3,
                noOfRating: ratingStars[2],
                totalRatings: totalRatings,
              ),
              RatingBar(
                rating: '2',
                color: AppTheme.rating_2,
                noOfRating: ratingStars[1],
                totalRatings: totalRatings,
              ),
              RatingBar(
                rating: '1',
                color: AppTheme.rating_1,
                noOfRating: ratingStars[0],
                totalRatings: totalRatings,
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
              Text(Strings.ratings,
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
  final OrderStatus orderStatus;

  RecentOrderWidget(
      {this.orderNo,
      this.orderValue,
      this.units,
      this.discount,
      this.date,
      this.isPaid,
      this.name,
      this.address,
      this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => orderStatus == OrderStatus.PENDING
                ? PendingOrder(orderNo)
                : OrderPage(
                    orderNo,
                  ),
          ),
        );
      },
      child: Container(
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
                    '${Strings.orderValue}:\nRs. $orderValue',
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
                    '${Strings.totalUnits}: $units',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondary_color),
                  ),
                  Text(
                    '${Strings.totalDiscount}:\nRs. $discount',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                        margin: EdgeInsets.only(left: 3),
                        child: Text(
                          isPaid ? Strings.paid : Strings.cod,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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

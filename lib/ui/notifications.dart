import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/notification_bloc.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/vendor_database_provider.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/data_placeholder.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

import '../util/strings_en.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationBloc notificationBloc;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        body: StreamBuilder(
          stream: notificationBloc.notificationStream,
          builder: (BuildContext context,
              AsyncSnapshot<DbResponse<List<NotificationModel>>> snapshot) {
            print(snapshot.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.secondary_color),
                  ),
                ),
              );
            } else {
              return snapshot.data.data.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: NoDataPlaceholderWidget(
                          imageUrl: 'notifications_placeholder.png',
                          info: Strings.notificationPlaceholder,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: Text(
                            '${snapshot.data.data.length} ${Strings.newNotifications}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                          itemCount: snapshot.data.data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            ///Return Single Widget
                            return NotificationWidget(
                              title: snapshot.data.data[index].title,
                              body: snapshot.data.data[index].body,
                              date: snapshot.data.data[index].receivedAt,
                            );
                          },
                        ),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    showNoti();
    notificationBloc = NotificationBloc();
    notificationBloc.getNotifications();
  }

//  void showNoti() async {
//    VendorDatabaseProvider vendorDatabaseProvider = VendorDatabaseProvider();
//    await vendorDatabaseProvider.open();
//    dynamic response =
//        await vendorDatabaseProvider.db.rawQuery('SELECT * FROM notification');
//    print(response.toString());
//  }
}

class NotificationWidget extends StatelessWidget {
  final String title;
  final String date;
  final String body;
  final Action action;

  NotificationWidget({this.title, this.date, this.body, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/orders.png',
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(title,
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Text(date,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.w600))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            child: Text(body,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }
}

enum Action { NEW_ORDER, NEW_REVIEW, ORDER_COMPLETED, PAYMENT_RELATED }

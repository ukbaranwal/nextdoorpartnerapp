import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nextdoorpartner/bloc/coupons_bloc.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/coupon.dart';
import 'package:nextdoorpartner/ui/data_placeholder.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/date_converter.dart';
import 'package:shimmer/shimmer.dart';

import '../util/strings_en.dart';

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  CouponsBloc couponsBloc;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));
  @override
  void initState() {
    super.initState();
    couponsBloc = CouponsBloc();
    couponsBloc.getCoupons();
  }

  @override
  void dispose() {
    couponsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: AppTheme.background_grey,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<ApiResponse<List<CouponModel>>>(
                stream: couponsBloc.couponsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<ApiResponse<List<CouponModel>>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    print(snapshot);
                    return Column(
                      children: [
                        InkWell(
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Container(
                              padding: EdgeInsets.all(18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Strings.addCoupon,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: AppTheme.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Coupon(
                                    isNewCoupon: true,
                                  ),
                                ));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 10),
                          child: Text(
                            snapshot.data.data.length == 0
                                ? Strings.noCampaigns
                                : Strings.runningCampaigns,
                            style: TextStyle(
                                color: AppTheme.secondary_color,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        snapshot.data.data.length == 0
                            ? NoDataPlaceholderWidget(
                                imageUrl: 'coupon_placeholder.png',
                                info: Strings.noCouponsPlaceholder,
                                extraInfo: Strings.tapOnGreen,
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 2),
                                itemCount: snapshot.data.data.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  ///Return Single Widget
                                  return CouponWidget(
                                      snapshot.data.data[index]);
                                },
                              ),
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(top: 20),
                      color: Colors.white,
                      child: Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        baseColor: Colors.grey[200],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 30,
                              ),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              itemCount: 5,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 20,
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
                                              160,
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
                                              190,
                                          decoration: boxDecoration,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CouponWidget extends StatelessWidget {
  final CouponModel couponModel;

  CouponWidget(this.couponModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Coupon(
                  couponModel: couponModel,
                  isNewCoupon: false,
                )));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${couponModel.discount}% OFF',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${Strings.max}: Rs.${couponModel.maxDiscount}',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${Strings.minOrder}: Rs.${couponModel.minOrder}',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            couponModel.code,
                            style: TextStyle(
                                color: AppTheme.green,
                                fontSize: 24,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '${Strings.startsOn} ${DateConverter.convertMonthDate(couponModel.startDate).toUpperCase()}\n${Strings.expiresOn} ${DateConverter.convertMonthDate(couponModel.endDate).toUpperCase()}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    '${couponModel.name}\n${couponModel.description}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppTheme.background_grey),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppTheme.background_grey),
            ),
          )
        ],
      ),
    );
  }
}

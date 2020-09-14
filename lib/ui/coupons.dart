import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/coupons_bloc.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/coupon.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  CouponsBloc couponsBloc;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Coupon(
                                  isNewCoupon: true,
                                ),
                              ));
                        },
                        child: Text(
                          'Add New Coupon',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22),
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: AppTheme.green,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              StreamBuilder<ApiResponse<List<CouponModel>>>(
                  stream: couponsBloc.couponsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ApiResponse<List<CouponModel>>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      print(snapshot);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              'Running Campaigns',
                              style: TextStyle(
                                  color: AppTheme.secondary_color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 2),
                            itemCount: snapshot.data.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              ///Return Single Widget
                              return CouponWidget(snapshot.data.data[index]);
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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
    return Stack(
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
                          'MAX: Rs.${couponModel.maxDiscount}',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'MIN ORDER: Rs.${couponModel.minOrder}',
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
                          'EXPIRES ON 03/12',
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
                  couponModel.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
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
    );
  }
}

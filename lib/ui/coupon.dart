import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nextdoorpartner/bloc/coupon_bloc.dart';
import 'package:nextdoorpartner/models/coupon_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/calendar_popup_view.dart';
import 'package:nextdoorpartner/ui/coupon_product.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/date_converter.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

import 'coupons.dart';

class Coupon extends StatefulWidget {
  final bool isNewCoupon;
  final CouponModel couponModel;

  Coupon({this.isNewCoupon, this.couponModel});

  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  CouponBloc couponBloc;
  int discount;
  double maxDiscount;
  double minOrder;

  List<int> selectProductIds = List<int>();
  BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)));
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController codeTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController maxDiscountTextEditingController =
      TextEditingController();
  final TextEditingController discountTextEditingController =
      TextEditingController();
  final TextEditingController minOrderTextEditingController =
      TextEditingController();

  Applicability applicability;

  ProgressDialog progressDialog;

  FocusScopeNode nameFocusNode = FocusScopeNode();
  FocusScopeNode codeFocusNode = FocusScopeNode();
  FocusScopeNode descriptionFocusNode = FocusScopeNode();
  FocusScopeNode maxDiscountFocusNode = FocusScopeNode();
  FocusScopeNode discountFocusNode = FocusScopeNode();
  FocusScopeNode minOrderFocusNode = FocusScopeNode();

  bool isAlreadyPopulated = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  changeFocus(FocusScopeNode focusScopeNode) {
    focusScopeNode.unfocus();
    FocusScopeNode focusScopeNode2;
    if (focusScopeNode == nameFocusNode) {
      focusScopeNode2 = descriptionFocusNode;
    } else if (focusScopeNode == descriptionFocusNode) {
      focusScopeNode2 = codeFocusNode;
    } else if (focusScopeNode == codeFocusNode) {
      focusScopeNode2 = discountFocusNode;
    } else if (focusScopeNode == discountFocusNode) {
      focusScopeNode2 = maxDiscountFocusNode;
    } else if (focusScopeNode == maxDiscountFocusNode) {
      focusScopeNode2 = minOrderFocusNode;
    } else if (focusScopeNode == minOrderFocusNode) {}
    FocusScope.of(context).requestFocus(focusScopeNode2);
  }

  void checkForValidation() {
    discount = int.tryParse(discountTextEditingController.text) ?? 0;
    maxDiscount = double.tryParse(maxDiscountTextEditingController.text) ?? 0;
    minOrder = double.tryParse(minOrderTextEditingController.text) ?? 0;
    if (nameTextEditingController.text.length == 0) {
      CustomToast.show('name field can\'t be empty', context);
      return;
    } else if (codeTextEditingController.text.length < 5) {
      CustomToast.show('Coupon Code should be of at least 5 Digits', context);
      return;
    } else if (discount <= 0 || discount >= 100) {
      CustomToast.show('Discount should be in between 0-100', context);
      return;
    } else if (maxDiscount <= 0) {
      CustomToast.show('Provide the maximum discount', context);
      return;
    } else if (minOrder <= 0) {
      CustomToast.show('Provide the Minimum Order', context);
      return;
    } else if (applicability == null) {
      CustomToast.show('Select the type of coupon', context);
      return;
    }
    widget.isNewCoupon ? uploadToServer() : updateProduct();
  }

  void selectAvailability(Applicability availability) async {
    if (availability == Applicability.PRODUCT_WISE) {
      selectProductIds = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  CouponProduct(selectProductIds)));
      if (selectProductIds.length > 0) {
        setState(() {
          this.applicability = availability;
        });
      }
    } else {
      setState(() {
        this.applicability = availability;
      });
    }
  }

  void uploadToServer() {
    CouponModel couponModel = CouponModel(
        nameTextEditingController.text,
        descriptionTextEditingController.text,
        codeTextEditingController.text,
        discount,
        maxDiscount,
        minOrder,
        startDate.toString(),
        endDate.toString(),
        applicability,
        applicability == Applicability.PRODUCT_WISE ? selectProductIds : null);
    couponBloc.addCoupon(couponModel);
    couponBloc.couponStream.listen((event) {
      if (event.status == Status.SUCCESSFUL) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Coupons()));
      }
    });
  }

  void updateProduct() {
    CouponModel couponModel = CouponModel(
        nameTextEditingController.text,
        descriptionTextEditingController.text,
        codeTextEditingController.text,
        discount,
        maxDiscount,
        minOrder,
        startDate.toString(),
        endDate.toString(),
        applicability,
        applicability == Applicability.PRODUCT_WISE ? selectProductIds : null);
    couponBloc.updateCoupon(couponModel);
  }

  @override
  void initState() {
    super.initState();
    couponBloc = CouponBloc(widget.couponModel);
    couponBloc.init();
    couponBloc.couponStream.listen((event) {
      if (event.showToast) {
        CustomToast.show(event.message, context);
      }
      if (widget.isNewCoupon) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Coupons()));
      }
    });
  }

  void populateFields(CouponModel couponModel) {
    nameTextEditingController.text = couponModel.name;
    descriptionTextEditingController.text = couponModel.description;
    codeTextEditingController.text = couponModel.code;
    discountTextEditingController.text = couponModel.discount.toString();
    maxDiscountTextEditingController.text = couponModel.maxDiscount.toString();
    minOrderTextEditingController.text = couponModel.minOrder.toString();
    applicability = couponModel.applicability;
    print(applicability);
    startDate = DateTime.parse(couponModel.startDate);
    endDate = DateTime.parse(couponModel.endDate);
    selectProductIds = couponModel.applicableOn;
  }

  @override
  void dispose() {
    couponBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: InkWell(
          onTap: () {
            checkForValidation();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(color: AppTheme.green, boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, -1),
                  color: Colors.black.withOpacity(0.4))
            ]),
            child: Text(
              widget.isNewCoupon ? 'Add Coupon' : 'Update Coupon',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        backgroundColor: AppTheme.background_grey,
        body: StreamBuilder(
            stream: couponBloc.couponStream,
            builder:
                (context, AsyncSnapshot<ApiResponse<CouponModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (!widget.isNewCoupon && !isAlreadyPopulated) {
                  isAlreadyPopulated = true;
                  populateFields(snapshot.data.data);
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showDemoDialog(context: context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: boxDecoration,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${DateConverter.convertMonthDate(startDate.toString())}-${DateConverter.convertMonthDate(endDate.toString())}',
                                    style: TextStyle(
                                        color: AppTheme.secondary_color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          !widget.isNewCoupon
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: FSwitch(
                                    width: 60,
                                    height: 35,
                                    openColor: AppTheme.green,
                                    open: snapshot.data.data.isLive,
                                    onChanged: (value) {
                                      couponBloc.toggleIsLive();
                                    },
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: nameTextEditingController,
                        labelText: Strings.name,
                        changeFocus: changeFocus,
                        focusNode: nameFocusNode,
                        textInputType: TextInputType.name,
                        isMarginApplicable: false,
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: descriptionTextEditingController,
                        labelText: Strings.description,
                        changeFocus: changeFocus,
                        focusNode: descriptionFocusNode,
                        textInputType: TextInputType.name,
                        isMarginApplicable: true,
                        isMultiline: true,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: codeTextEditingController,
                        labelText: 'Coupon Code',
                        changeFocus: changeFocus,
                        focusNode: codeFocusNode,
                        textInputType: TextInputType.name,
                        isMarginApplicable: false,
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: discountTextEditingController,
                        labelText: 'Discount',
                        changeFocus: changeFocus,
                        focusNode: discountFocusNode,
                        textInputType: TextInputType.number,
                        isMarginApplicable: true,
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: maxDiscountTextEditingController,
                        labelText: 'Max Discount',
                        changeFocus: changeFocus,
                        focusNode: maxDiscountFocusNode,
                        textInputType: TextInputType.number,
                        isMarginApplicable: false,
                        isMultiline: false,
                      ),
                      ProductTextInputWidget(
                        boxDecoration: boxDecoration,
                        textInputAction: TextInputAction.next,
                        textEditingController: minOrderTextEditingController,
                        labelText: 'Minimum Order',
                        changeFocus: changeFocus,
                        focusNode: minOrderFocusNode,
                        textInputType: TextInputType.number,
                        isMarginApplicable: true,
                        isMultiline: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AvailabilityWidget(
                                  label: 'All Products',
                                  isSelected:
                                      applicability == Applicability.ALL,
                                  applicability: Applicability.ALL,
                                  callback: selectAvailability,
                                ),
                                AvailabilityWidget(
                                  label: 'First Timers',
                                  isSelected: applicability ==
                                      Applicability.FIRST_TIMER,
                                  applicability: Applicability.FIRST_TIMER,
                                  callback: selectAvailability,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AvailabilityWidget(
                              label: 'Product Wise',
                              isSelected:
                                  applicability == Applicability.PRODUCT_WISE,
                              applicability: Applicability.PRODUCT_WISE,
                              callback: selectAvailability,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

class AvailabilityWidget extends StatelessWidget {
  final String label;
  final Applicability applicability;
  final Function callback;

  final bool isSelected;

  AvailabilityWidget(
      {this.label, this.applicability, this.callback, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback(applicability);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5 - 15,
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.green : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.all(10),
        child: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.secondary_color,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
    );
  }
}

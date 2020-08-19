import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nextdoorpartner/ui/app_bar.dart';
import 'package:nextdoorpartner/ui/product.dart';
import 'package:nextdoorpartner/ui/product_category.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          width: 60,
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
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => Products(),
//              ),
//            );
            },
            elevation: 10,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.tune,
              color: AppTheme.secondary_color,
              size: 32,
            ),
          ),
        ),
        backgroundColor: AppTheme.background_grey,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
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
                                builder: (context) => ProductCategory(),
                              ));
                        },
                        child: Text(
                          Strings.addNewProduct,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.search,
                      color: AppTheme.grey,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        cursorColor: AppTheme.secondary_color,
                        onFieldSubmitted: (value) => {},
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondary_color,
                            fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.grey,
                                fontSize: 18),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 10, bottom: 11, top: 11, right: 10),
                            hintText: Strings.search),
                        onEditingComplete: () {},
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.highlight_off,
                        color: AppTheme.grey,
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              ),
              ProductWidget(
                inStockSwitch: FSwitch(
                  width: 40,
                  height: 20,
                  openColor: AppTheme.green,
                  open: true,
                  onChanged: (value) {
                    setState(() {
//                              isSwitchedOn = value;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final Widget inStockSwitch;

  ProductWidget({this.inStockSwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/walkthrough_1.png',
                height: 80,
                width: 80,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'maggi',
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  Text(
                    'nestle',
                    style: TextStyle(
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  Text(
                    'mrp: Rs. 10',
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  Text(
                    'selling price: Rs. 6',
                    style: TextStyle(
                        color: AppTheme.secondary_color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                        color: AppTheme.background_grey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Text(
                          '4',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w800,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.photo,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                        color: AppTheme.background_grey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Text(
                          '180',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w800,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.shopping_cart,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                        color: AppTheme.background_grey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Text(
                          '400',
                          style: TextStyle(
                              color: AppTheme.secondary_color,
                              fontWeight: FontWeight.w800,
                              fontSize: 12),
                        ),
                        Icon(
                          Icons.remove_red_eye,
                          size: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: 5,
                    itemSize: 14,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Text(
                        '40% off',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    Strings.inStock,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.green,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  inStockSwitch
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

import '../util/strings_en.dart';

class NewOrder extends StatelessWidget {
  final int id;

  NewOrder(this.id);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Strings.congratsNewOrder,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontWeight: FontWeight.w800,
                      fontSize: 24),
                ),
                Image.asset(
                  'assets/images/new_order.gif',
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  color: AppTheme.green,
                  child: Text(
                    Strings.viewOrder,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22),
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

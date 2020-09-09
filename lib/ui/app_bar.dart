import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nextdoorpartner/models/vendor_model.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/strings_en.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool hideShadow;

  CustomAppBar({this.hideShadow = false});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSwitchedOn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: widget.hideShadow
              ? []
              : [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 2))
                ],
          color: Colors.white,
          borderRadius: widget.hideShadow
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0))
              : BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Text(
            vendorModelGlobal.shopName,
            style: TextStyle(
                color: AppTheme.secondary_color,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          Text(vendorModelGlobal.shopOpen ? Strings.online : 'Offline',
              style: TextStyle(
                  color:
                      vendorModelGlobal.shopOpen ? AppTheme.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

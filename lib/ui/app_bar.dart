import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fswitch/fswitch.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isDashboard;

  CustomAppBar({this.isDashboard});

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
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              RatingBarIndicator(
                rating: 5,
                itemSize: 18,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'RS Stores',
                      style: TextStyle(
                          color: AppTheme.secondary_color,
                          fontSize: 22,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.secondary_color,
                    size: 20,
                  )
                ],
              )
            ],
          ),
          widget.isDashboard
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: FSwitch(
                    width: 60,
                    height: 30,
                    openColor: AppTheme.green,
                    open: isSwitchedOn,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedOn = value;
                      });
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

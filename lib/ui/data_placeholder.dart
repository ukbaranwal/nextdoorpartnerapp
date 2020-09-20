import 'package:flutter/material.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class NoDataPlaceholderWidget extends StatelessWidget {
  final String imageUrl;
  final String info;
  final String extraInfo;

  NoDataPlaceholderWidget({this.imageUrl, this.info, this.extraInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.18),
      child: Column(
        children: [
          Image.asset(
            'assets/images/$imageUrl',
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            info,
            style: TextStyle(
                color: AppTheme.secondary_color,
                fontWeight: FontWeight.w700,
                fontSize: 22),
          ),
          extraInfo != null
              ? Text(
                  extraInfo,
                  style: TextStyle(
                      color: AppTheme.secondary_color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

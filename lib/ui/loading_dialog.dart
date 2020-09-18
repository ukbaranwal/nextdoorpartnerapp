import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/util/app_theme.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          RefreshProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.secondary_color,
            ),
          ),
        ],
      ),
    );
  }
}

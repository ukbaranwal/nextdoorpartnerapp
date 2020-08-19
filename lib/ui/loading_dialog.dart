import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Loading Dialog
///@author <a href="mailto:ukbaranwal@gmail.com">Utkarsh Baranwal</a>
class LoadingDialog extends StatefulWidget {
  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animationController,
        child: Container(
          height: 60,
          width: 60,
          child: Image.asset('assets/images/a.jpg'),
        ),
        builder: (BuildContext context, Widget _widget) {
          return Transform.rotate(
            angle: animationController.value * 10,
            child: _widget,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 10),
    );
    animationController.repeat();
  }
}

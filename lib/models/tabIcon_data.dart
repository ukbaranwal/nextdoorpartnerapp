import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TabIconData {
  TabIconData(
      {this.icon,
      this.index = 0,
      this.isSelected = false,
      this.animationController,
      this.text});

  IconData icon;
  String text;
  bool isSelected;
  int index;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
        icon: Icons.shopping_basket,
        index: 0,
        isSelected: true,
        animationController: null,
        text: 'products'),
    TabIconData(
        icon: Icons.textsms,
        index: 1,
        isSelected: false,
        animationController: null,
        text: 'reviews'),
    TabIconData(
        icon: Icons.credit_card,
        index: 2,
        isSelected: false,
        animationController: null,
        text: 'payments'),
    TabIconData(
        icon: Icons.apps,
        index: 3,
        isSelected: false,
        animationController: null,
        text: 'menu'),
  ];
}

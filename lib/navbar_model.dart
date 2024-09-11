import 'package:flutter/material.dart';

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navigatorKey;

  NavModel({required this.page, required this.navigatorKey});
}

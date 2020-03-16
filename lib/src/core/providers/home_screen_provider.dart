import 'package:flutter/material.dart';

class HomeScreenProvider {
  int currentIndex = 0;
  final _navigators = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  List<GlobalKey<NavigatorState>> get navigators => _navigators;

  void dispose() {}
}

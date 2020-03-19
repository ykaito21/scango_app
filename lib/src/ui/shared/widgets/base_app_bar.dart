import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'ScanGo',
        style: TextStyle(
          fontSize: 48.0,
          fontFamily: 'Lobster',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../global/extensions.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String titleText;
  final Function onTap;
  const DrawerTile({
    Key key,
    @required this.icon,
    @required this.titleText,
    @required this.onTap,
  })  : assert(icon != null),
        assert(titleText != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.accentColor,
      ),
      title: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}

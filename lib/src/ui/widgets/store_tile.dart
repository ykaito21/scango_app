import 'package:flutter/material.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';

class StoreTile extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final Function onTap;
  const StoreTile({
    Key key,
    @required this.titleText,
    @required this.subtitleText,
    @required this.onTap,
  })  : assert(titleText != null),
        assert(subtitleText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //* brand logo image could be added
    return ListTile(
      onTap: onTap,
      title: Text(
        titleText,
        style: StyleList.smallBoldTextStyle.copyWith(
          color: context.accentColor,
        ),
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        subtitleText,
        style: StyleList.smallBoldTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../global/style_list.dart';
import '../../global/extensions.dart';

class BaseButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const BaseButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
  })  : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: StyleList.allPadding10,
        child: Text(
          buttonText,
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      color: context.accentColor,
      textColor: context.primaryColor,
      disabledColor: context.accentColor.withOpacity(0.5),
      disabledTextColor: context.primaryColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        // side: BorderSide(
        //   color: context.accentColor,
        // ),
      ),
    );
  }
}

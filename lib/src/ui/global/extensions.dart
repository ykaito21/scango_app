import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';

extension ContextExtensions on BuildContext {
  // Navigation
  bool pop<T extends Object>([T result]) => Navigator.of(this).pop(result);
  Future<T> pushNamed<T extends Object>(String path,
          {Object arguments,
          bool rootNavigator = false,
          bool nullOk = false}) =>
      Navigator.of(this, rootNavigator: rootNavigator, nullOk: nullOk)
          .pushNamed(
        path,
        arguments: arguments,
      );

  // Color
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).accentColor;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get appliedSlidableColor => Theme.of(this).brightness == Brightness.dark
      ? Colors.black
      : Colors.white;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

// Device Size
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  // Provider
  T provider<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);

  // Localization
  String translate(String key) => AppLocalizations.of(this).translate(key);

  String get lang => Localizations.localeOf(this).languageCode;

  String localizeAlertTtile(String content, String key) {
    switch (this.lang) {
      case 'en':
        return '${this.translate(key)} "$content"${this.translate('questionMark')}';
      case 'ja':
        return '"$content"${this.translate(key)}${this.translate('questionMark')}';
      default:
        return '${this.translate(key)} "$content"${this.translate('questionMark')}';
    }
  }

  String localizeMessage(String content, String key) {
    switch (this.lang) {
      case 'en':
        return '"$content" ${this.translate(key)}';
      case 'ja':
        return '"$content"${this.translate(key)}';
      default:
        return '"$content" ${this.translate(key)}';
    }
  }

  // SnackBar
  SnackBar baseSnackBar(
    String snackBarText,
  ) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      backgroundColor: this.accentColor,
      content: Text(
        snackBarText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: this.primaryColor,
        ),
      ),
    );
  }

  // Focus
  void get unfocus => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  // TextStyle
  TextStyle get baseTextStyleWithAccent => TextStyle(
        color: this.accentColor,
        fontSize: 48.0,
        fontWeight: FontWeight.w900,
      );
}

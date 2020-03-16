import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global/color_list.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemes = {
  AppTheme.Light: ThemeData().copyWith(
    primaryColor: ColorList.primaryCream,
    accentColor: ColorList.primaryOrange,
    scaffoldBackgroundColor: Colors.grey[50],
    cupertinoOverrideTheme: CupertinoThemeData(
      //* for cursor color
      primaryColor: ColorList.primaryOrange,
      //* for alertDialog color
      brightness: Brightness.light,
    ),
    cursorColor: ColorList.primaryOrange,
    appBarTheme: AppBarTheme(
      //* for status bar
      brightness: Brightness.light,
      color: Colors.grey[50],
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.primaryOrange,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.primaryOrange,
      ),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorList.primaryOrange,
    ),
  ),
  AppTheme.Dark: ThemeData.dark().copyWith(
    primaryColor: ColorList.primaryBlue,
    accentColor: ColorList.primaryCream,
    scaffoldBackgroundColor: Colors.grey[850],
    cupertinoOverrideTheme: CupertinoThemeData(
      //* for cursor color
      primaryColor: ColorList.primaryCream,
      //* for alertDialog color
      brightness: Brightness.dark,
    ),
    cursorColor: ColorList.primaryCream,
    appBarTheme: AppBarTheme(
      //* for status bar
      brightness: Brightness.dark,
      color: Colors.grey[850],
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.primaryCream,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.primaryCream,
      ),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorList.primaryCream,
    ),
  ),
};

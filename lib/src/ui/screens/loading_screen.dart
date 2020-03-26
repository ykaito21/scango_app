import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../global/extensions.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Shimmer.fromColors(
          baseColor: context.accentColor,
          highlightColor: context.scaffoldBackgroundColor,
          child: Text(
            'ScanGo',
            style: TextStyle(
              fontSize: 48.0,
              fontFamily: 'Lobster',
            ),
          ),
        ),
      ),
    );
  }
}

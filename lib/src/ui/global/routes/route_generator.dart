import 'package:flutter/material.dart';
import '../../screens/auth_screen.dart';
// import '../../screens/initial_screen.dart';
import '../../screens/home_screen.dart';
import '../style_list.dart';
import '../extensions.dart';
import 'route_path.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      //* if you want to check auth before anything
      // case RoutePath.initialScreen:
      //   return MaterialPageRoute(builder: (context) => InitialScreen());
      case RoutePath.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RoutePath.authScreen:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AuthScreen(),
        );
      // case RoutePath.writeMealScreen:
      // if (args is MealWithTags) {
      // return MaterialPageRoute(
      //   builder: (context) => WriteMealScreenWrapper(
      //     mealWithTags: args,
      //   ),
      // );
      // }
      // return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(
              context.translate('error'),
              style: StyleList.baseTitleTextStyle,
            ),
          ),
        );
      },
    );
  }
}

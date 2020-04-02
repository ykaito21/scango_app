import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../screens/auth_screen.dart';
// import '../../screens/initial_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/account_settings_screen.dart';
import '../../screens/store_edit_screen.dart';
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
      case RoutePath.productDetailScreen:
        if (args is ProductModel) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productItem: args,
            ),
          );
        }
        return _errorRoute();
      case RoutePath.accountSettingsScreen:
        return MaterialPageRoute(
          builder: (context) => AccountSettingsScreen(),
        );
      case RoutePath.storeEditScreen:
        return MaterialPageRoute(
          builder: (context) => StoreEditScreen(),
        );

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

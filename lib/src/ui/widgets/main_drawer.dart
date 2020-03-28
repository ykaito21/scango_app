import 'package:flutter/material.dart';
import '../../core/providers/app_providers/auth_provider.dart';
import '../global/routes/route_path.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/widgets/unauthenticated_card.dart';

import 'drawer_tile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* don't need to listen auth state change
    final user = context.provider<AuthProvider>().user;
    final bool unauthenticated = user == null;
    return Drawer(
      child: ListView(
        padding: StyleList.removePadding,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Container(
                  height: 75.0,
                  child: Image.asset('assets/images/logo.png'),
                ),
                StyleList.verticalBox20,
                Text(
                  unauthenticated
                      ? context.translate('guest')
                      : user.firstName.isNotEmpty ? user.firstName : 'ScanGo',
                  style: StyleList.baseSubtitleTextStyle,
                )
              ],
            ),
            decoration: BoxDecoration(
                // color: Colors.blue,
                ),
          ),
          if (unauthenticated) UnauthenticatedCard(),
          DrawerTile(
            icon: Icons.store,
            titleText: context.translate('editStore'),
            onTap: () {},
          ),
          if (!unauthenticated) ...[
            DrawerTile(
              icon: Icons.edit,
              titleText: context.translate('editProfile'),
              onTap: () {},
              // onTap: () =>
              //     Navigator.pushNamed(context, RoutePath.profileEditScreen),
            ),
            DrawerTile(
              icon: Icons.receipt,
              titleText: context.translate('orderHistory'),
              onTap: () {},
              // onTap: () =>
              //     Navigator.pushNamed(context, RoutePath.orderHistoryScreen),
            ),
            DrawerTile(
              icon: Icons.payment,
              titleText: context.translate('paymentMethods'),
              onTap: () {},
              // onTap: () =>
              //     Navigator.pushNamed(context, RoutePath.paymentMethodsScreen),
            ),
            DrawerTile(
              icon: Icons.settings,
              titleText: context.translate('accountSettings'),
              onTap: () =>
                  Navigator.pushNamed(context, RoutePath.accountSettingsScreen),
            ),
          ]
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/home_screen_provider.dart';
import '../global/routes/route_generator.dart';
import '../global/extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenProvider>(
      create: (context) => HomeScreenProvider(),
      dispose: (context, homeScreenProvider) => homeScreenProvider.dispose(),
      child: Consumer<HomeScreenProvider>(
        builder: (context, homeScreenProvider, child) {
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async => !await homeScreenProvider
                  .navigators[homeScreenProvider.currentIndex].currentState
                  .maybePop(),
              child: CupertinoTabScaffold(
                resizeToAvoidBottomInset: false,
                tabBuilder: (context, index) {
                  return CupertinoTabView(
                    navigatorKey: homeScreenProvider.navigators[index],
                    onGenerateRoute: RouteGenerator.generateRoute,
                    builder: (context) {
                      switch (index) {
                        case 0:
                          return Container();
                        case 1:
                          return Container();
                        default:
                          return Container();
                      }
                    },
                  );
                },
                tabBar: CupertinoTabBar(
                  border: Border(
                    top: BorderSide(
                      color: context.scaffoldBackgroundColor,
                      width: 0.0, // One physical pixel.
                      style: BorderStyle.solid,
                    ),
                  ),
                  backgroundColor: context.scaffoldBackgroundColor,
                  activeColor: context.accentColor,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      // title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                    ),
                  ],
                  onTap: (index) {
                    if (homeScreenProvider.currentIndex == index) {
                      homeScreenProvider.navigators[index].currentState
                          .popUntil((route) => route.isFirst);
                    }
                    homeScreenProvider.currentIndex = index;
                  },
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: (Platform.isIOS)
                  ? const EdgeInsets.only(bottom: 30.0)
                  : const EdgeInsets.only(bottom: 0.0),
              child: FloatingActionButton(
                child: Icon(Icons.crop_free),
                onPressed: () => null,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

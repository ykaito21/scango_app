import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/store_model.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/app_providers/cart_provider.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../../core/providers/screen_providers/home_screen_provider.dart';
import '../global/routes/route_generator.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../widgets/main_drawer.dart';
import '../widgets/store_product_search_delegate.dart';
import 'featured_products_screen.dart';
import 'cart_screen.dart';
import 'loading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.provider<CartProvider>();
    return Selector<StoreProvider, StoreModel>(
      selector: (context, storeProvider) => storeProvider.store,
      builder: (context, store, child) {
        if (store == null) return LoadingScreen();
        return Provider<HomeScreenProvider>(
          create: (context) => HomeScreenProvider(),
          dispose: (context, homeScreenProvider) =>
              homeScreenProvider.dispose(),
          child: Consumer<HomeScreenProvider>(
            builder: (context, homeScreenProvider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    store.name,
                    style: StyleList.smallBoldTextStyle,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => showSearch(
                          context: context,
                          delegate: StoreProductSearchDelegate()),
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                drawer: MainDrawer(),
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
                              return FeaturedProductsScreen();
                            case 1:
                              return CartScreen();
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
                        //! bug need to fix flickering with streamBuilder when tab change
                        BottomNavigationBarItem(
                          icon: StreamBuilder<List<CartModel>>(
                            stream: cartProvider.streamCart,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data.isNotEmpty)
                                return Badge(
                                  badgeColor: context.accentColor,
                                  toAnimate: false,
                                  badgeContent:
                                      _badgeText(context, snapshot.data.length),
                                  child: Icon(Icons.shopping_cart),
                                );
                              return Icon(Icons.shopping_cart);
                            },
                          ),
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
      },
    );
  }

  Widget _badgeText(BuildContext context, int quantity) {
    return Text(
      '$quantity',
      style: TextStyle(
        color: context.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

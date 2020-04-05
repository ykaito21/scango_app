import 'package:badges/badges.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_providers/product_provider.dart';
import '../../core/models/store_model.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/app_providers/cart_provider.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../../core/providers/screen_providers/home_screen_provider.dart';
import '../global/routes/route_generator.dart';
import '../global/routes/route_path.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../widgets/main_drawer.dart';
import '../widgets/store_product_search_delegate.dart';
import 'featured_products_screen.dart';
import 'cart_screen.dart';
import 'loading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  Future<void> requestPermission(BuildContext context) async {
    await PlatformAlertDialog(
      title: context.translate('changeSettings'),
      content: context.translate('pleaseAllowAccess'),
      defaultActionText: 'OK',
    ).show(context);
    openAppSettings();
  }

  Future<void> _scanCode(BuildContext context) async {
    final res = await Permission.camera.status;
    if (res == PermissionStatus.denied) {
      requestPermission(context);
    } else {
      final productProvider = context.provider<ProductProvider>();
      try {
        final code = await BarcodeScanner.scan();
        final scannedProductList =
            await productProvider.searchProductByCode(code);
        print(scannedProductList);
        if (scannedProductList.isEmpty) {
          await PlatformAlertDialog(
            title: context.translate('noMatchedProduct'),
            content: context.translate('noMatchedProductWithCode'),
            defaultActionText: 'OK',
          ).show(context);
        } else {
          context.pushNamed(RoutePath.productDetailScreen,
              arguments: scannedProductList.first);
        }
      } catch (e) {
        if (e.code != BarcodeScanner.UserCanceled) {
          PlatformExceptionAlertDialog(
            title: context.translate('error'),
            exception: e,
            context: context,
          ).show(context);
        }
      }
    }
  }

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
              print(store);
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
                //* on iphone 11 floating action button position is way below
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _scanCode(context),
                  child: Icon(Icons.crop_free),
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

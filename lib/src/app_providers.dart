import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/providers/app_providers/auth_provider.dart';
import 'core/providers/app_providers/cart_provider.dart';
import 'core/providers/app_providers/product_provider.dart';
import 'core/providers/app_providers/promotion_provider.dart';
import 'core/providers/app_providers/store_provider.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
  ...uiProviders,
];

List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider<AuthProvider>(
    create: (_) => AuthProvider(),
  ),
  ChangeNotifierProvider<StoreProvider>(
    create: (_) => StoreProvider(),
  ),
];

List<SingleChildWidget> dependentProviders = [
  ChangeNotifierProxyProvider<StoreProvider, PromotionProvider>(
    create: (_) => PromotionProvider(),
    update: (_, storeProvider, promotionProvider) =>
        promotionProvider..currentStore = storeProvider.store,
  ),
  ChangeNotifierProxyProvider<StoreProvider, ProductProvider>(
    create: (_) => ProductProvider(),
    update: (_, storeProvider, productProvider) =>
        productProvider..currentStore = storeProvider.store,
  ),
  ChangeNotifierProxyProvider2<AuthProvider, StoreProvider, CartProvider>(
    create: (_) => CartProvider(),
    update: (_, authProvider, storeProvider, cartProvider) {
      cartProvider.currentUser = authProvider.user;
      cartProvider.currentStore = storeProvider.store;
      return cartProvider;
    },
  ),
];

List<SingleChildWidget> uiProviders = [];

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/providers/app_providers/auth_provider.dart';
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
        promotionProvider..currentStore = storeProvider.currentStore,
  ),
  ChangeNotifierProxyProvider<StoreProvider, ProductProvider>(
    create: (_) => ProductProvider(),
    update: (_, storeProvider, productProvider) =>
        productProvider..currentStore = storeProvider.currentStore,
  ),
];

List<SingleChildWidget> uiProviders = [];

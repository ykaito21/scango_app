import 'package:flutter/foundation.dart';

class ApiPath {
  static String stores() => 'stores';
  static String store(String storeId) => 'stores/$storeId';
  static String storePromotions(String storeId) => 'stores/$storeId/promotions';
  // static String storePromotionProducts(String storeId, String promotionId) =>
  //     'stores/$storeId/promotions/$promotionId/products';
  static String storeFeaturedProducts(String storeId) =>
      'stores/$storeId/featuredProducts';
  static String storeCart(String userId, String storeId) =>
      'users/$userId/stores/$storeId/cart';
  static String storeCartItem(
          String userId, String storeId, String cartItemId) =>
      'users/$userId/stores/$storeId/cart/$cartItemId';
  static String storeOrders(String userId, String storeId) =>
      'users/$userId/stores/$storeId/orders';

  static String user(userId) => 'users/$userId';

  static String categories() => 'categories';
  static String products() => 'products';
  static String cart({@required String userId}) => 'users/$userId/cart';
  static String cartItem(
          {@required String userId, @required String cartItemId}) =>
      'users/$userId/cart/$cartItemId';
  static String orders({@required String userId}) => 'users/$userId/orders';
  static String orderItem(
          {@required String userId, @required String orderItemId}) =>
      'users/$userId/orders/$orderItemId';
  static String userAvatar({@required userId}) => 'users/$userId/avatar.jpg';

// Stripe
  static String stripeSources({@required String userId}) =>
      'stripe/$userId/sources';
  static String stripeInfo({@required String userId}) => 'stripe/$userId';
}

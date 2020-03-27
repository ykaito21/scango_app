import 'package:flutter/material.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/app_providers/auth_provider.dart';
import '../../core/providers/app_providers/cart_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/stream_wrapper.dart';
import '../shared/widgets/unauthenticated_card.dart';
import '../widgets/cart_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* could be consumer and listen change but changing tab rebuild screen anyway
    return context.provider<AuthProvider>(listen: true).user == null
        ? UnauthenticatedCard()
        : StreamWrapper<List<CartModel>>(
            stream: context.provider<CartProvider>().streamCart,
            onError: (context, _) =>
                StyleList.errorViewState(context.translate('error')),
            onSuccess: (context, cart) {
              if (cart.isEmpty)
                return StyleList.emptyViewState(context.translate('emptyCart'));
              return CartList(cart: cart);
            },
          );
  }
}

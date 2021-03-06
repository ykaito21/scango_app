import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/app_providers/cart_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_button.dart';
// import '../shared/widgets/base_loading_button.dart';

import 'cart_card.dart';

class CartList extends StatelessWidget {
  final List<CartModel> cart;
  const CartList({
    Key key,
    @required this.cart,
  })  : assert(cart != null),
        super(key: key);

  Future<bool> _confirmDismiss(BuildContext context, CartModel cartItem) async {
    return await PlatformAlertDialog(
      title: context.localizeAlertTtile(
          cartItem.productItem.name, 'alertDeleteTitle'),
      content: context.translate('alertDeleteContentCartItem'),
      defaultActionText: context.translate('delete'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
  }

  Future<void> _onDismissedCartItem(
    BuildContext context,
    CartProvider cartProvider,
    CartModel cartItem,
  ) async {
    try {
      await cartProvider.removeCartItem(cartItem);
      //* optional
      // Scaffold.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(
      //     context.baseSnackBar(
      //       context.localizeMessage(cartItem.productItem.name, 'isRemoved'),
      //     ),
      //   );
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  Future<void> _onPressedBuy(
    BuildContext context,
    CartProvider cartProvider,
  ) async {
    final confirmation = await PlatformAlertDialog(
      title: context.translate('alertConfirmTitleCart'),
      content: context.translate('alertConfirmContentCart'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('no'),
    ).show(context);
    if (confirmation) {
      try {
        final code = await cartProvider.convertToOrder();
        PlatformAlertDialog(
          title: context.translate('orderCode'),
          content: '',
          defaultActionText: context.translate('confirm'),
          optionalContent: Container(
            padding: StyleList.topPadding10,
            child: Text(
              code.toString(),
              style: StyleList.mediumBoldTextStyle,
            ),
          ),
        ).show(context);
      } catch (e) {
        print(e);
        // if (e.code != 'cancelled')
        // PlatformExceptionAlertDialog(
        //   title: context.translate('error'),
        //   exception: e,
        //   context: context,
        // ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.provider<CartProvider>();
    return ModalProgressHUD(
      inAsyncCall: context.provider<CartProvider>(listen: true).isBusy,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final cartItem = cart[index];
                  return Dismissible(
                    key: ValueKey(cartItem),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (DismissDirection direction) async =>
                        await _confirmDismiss(context, cartItem),
                    onDismissed: (direction) =>
                        _onDismissedCartItem(context, cartProvider, cartItem),
                    background: Container(
                      padding: StyleList.rightPadding20,
                      alignment: Alignment.centerRight,
                      color: context.accentColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: context.primaryColor,
                            size: 40,
                          ),
                          Text(
                            context.translate('delete'),
                            style: StyleList.smallBoldTextStyle.copyWith(
                              color: context.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: StyleList.horizontalPadding20,
                      child: CartCard(cartItem: cartItem),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: StyleList.allPadding10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: StyleList.horizontalPadding10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        context.translate('total'),
                        style: StyleList.baseTitleTextStyle,
                      ),
                      Text(
                        context.localizePrice(cartProvider.totalPrice()),
                        style: StyleList.baseTitleTextStyle.copyWith(
                          color: context.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                StyleList.verticalBox10,
                BaseButton(
                  buttonText: context.translate('buy'),
                  onPressed: () => _onPressedBuy(context, cartProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

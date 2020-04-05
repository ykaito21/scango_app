import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_providers/auth_provider.dart';
import '../../core/providers/app_providers/cart_provider.dart';
import '../../core/models/product_model.dart';
import '../../core/providers/screen_providers/product_detail_screen_provider.dart';
// import '../../core/providers/cart_provider.dart';
import '../global/routes/route_path.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/widgets/cached_image.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_button.dart';
import '../widgets/row_quantity_counter.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel productItem;
  const ProductDetailScreen({
    Key key,
    @required this.productItem,
  })  : assert(productItem != null),
        super(key: key);

  Future<void> _onPressedAddToCart(
      BuildContext context,
      ProductModel productItem,
      ProductDetailScreenProvider productDetailScreenProvider) async {
    final quantity = productDetailScreenProvider.quantity;
    final currentUser = context.provider<AuthProvider>().user;
    if (currentUser == null) {
      context.pushNamed(RoutePath.authScreen, rootNavigator: true);
    } else {
      try {
        await context
            .provider<CartProvider>()
            .addCartItem(productItem: productItem, quantity: quantity);
        //* optional
        // Scaffold.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(
        //     context.baseSnackBar(
        //       context.localizeMessage(productItem.name, 'isAdded'),
        //     ),
        //   );
        context.pop();
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider<ProductDetailScreenProvider>(
        create: (context) => ProductDetailScreenProvider(),
        child: SingleChildScrollView(
          child: Padding(
            padding: StyleList.horizontalPadding10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        productItem.name,
                        style: StyleList.mediumBoldTextStyle,
                      ),
                    ),
                    Padding(
                      padding: StyleList.leftPadding20,
                      child: Text(
                        context.localizePrice(productItem.price),
                        style: StyleList.mediumBoldTextStyle.copyWith(
                          color: context.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                StyleList.verticalBox10,
                Container(
                  height: 300.0,
                  child: Hero(
                    tag: productItem.id,
                    child: CachedImage(
                      imageUrl: productItem.imageUrl,
                    ),
                  ),
                ),
                Text(
                  productItem.description,
                  style: StyleList.smallBoldTextStyle,
                ),
                StyleList.verticalBox30,
                RowQuantityCounter(),
                StyleList.verticalBox30,
                Consumer<ProductDetailScreenProvider>(
                  builder: (context, productDetailScreenProvider, child) {
                    return BaseButton(
                      buttonText: context.translate('addToCart'),
                      onPressed: () => _onPressedAddToCart(
                          context, productItem, productDetailScreenProvider),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

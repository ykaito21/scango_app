import 'package:flutter/material.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../widgets/featured_product_list.dart';
import '../widgets/promotion_slider.dart';

class FeaturedProductsScreen extends StatelessWidget {
  const FeaturedProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: PromotionSlider()),
        SliverToBoxAdapter(
          child: Padding(
            padding: StyleList.verticalHorizontalpadding1020,
            child: Text(
              context.translate(
                'recommendedToYou',
              ),
              style: StyleList.mediumBoldTextStyle,
            ),
          ),
        ),
        FeaturedProductList(),
      ],
    );
  }
}

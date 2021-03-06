import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/providers/app_providers/product_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../widgets/featured_product_card.dart';

class FeaturedProductList extends StatelessWidget {
  const FeaturedProductList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featuredProductList =
        context.provider<ProductProvider>(listen: true).featuredProductList;
    return SliverList(
      delegate: featuredProductList.isEmpty
          ? SliverChildBuilderDelegate(
              (context, index) {
                return Shimmer.fromColors(
                  baseColor: context.accentColor.withOpacity(0.5),
                  highlightColor: context.scaffoldBackgroundColor,
                  child: Container(
                    height: 100.0,
                    padding: StyleList.verticalHorizontalpadding510,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 100.0,
                          color: context.accentColor.withOpacity(0.5),
                        ),
                        StyleList.horizontalBox20,
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  height: 20.0,
                                  color: context.accentColor.withOpacity(0.5),
                                ),
                                Container(
                                  height: 20.0,
                                  color: context.accentColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 5,
            )
          : SliverChildBuilderDelegate(
              (context, index) {
                final featuredProduct = featuredProductList[index];
                final isSale =
                    featuredProduct.price != featuredProduct.originalPrice;
                return FeaturedProductCard(
                    featuredProduct: featuredProduct, isSale: isSale);
              },
              childCount: featuredProductList.length,
            ),
    );
  }
}

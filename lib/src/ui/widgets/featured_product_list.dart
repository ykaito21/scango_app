import 'package:flutter/material.dart';
import 'package:scango_app/src/ui/global/routes/route_path.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/providers/app_providers/product_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/cached_image.dart';

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
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    RoutePath.productDetailScreen,
                    arguments: featuredProduct,
                    rootNavigator: true,
                  ),
                  child: Container(
                    height: 100.0,
                    padding: StyleList.horizontalPadding10,
                    //* to work with onTap
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 100.0,
                          child: Hero(
                            tag: featuredProduct.id,
                            child: CachedImage(
                              imageUrl: featuredProduct.imageUrl,
                            ),
                          ),
                        ),
                        StyleList.horizontalBox20,
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  featuredProduct.name,
                                  style: StyleList.smallBoldTextStyle,
                                ),
                                Row(
                                  children: <Widget>[
                                    if (isSale)
                                      Padding(
                                        padding: StyleList.rightPadding20,
                                        child: Text(
                                          context.localizePrice(
                                            featuredProduct.originalPrice,
                                          ),
                                          style: StyleList.smallBoldTextStyle
                                              .copyWith(
                                            fontWeight: FontWeight.w300,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      context
                                          .localizePrice(featuredProduct.price),
                                      style: StyleList.smallBoldTextStyle,
                                    ),
                                  ],
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
              childCount: featuredProductList.length,
            ),
    );
  }
}

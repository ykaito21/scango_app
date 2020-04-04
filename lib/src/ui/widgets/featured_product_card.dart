import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../global/routes/route_path.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/cached_image.dart';

class FeaturedProductCard extends StatelessWidget {
  final ProductModel featuredProduct;
  final bool isSale;
  const FeaturedProductCard({
    Key key,
    @required this.featuredProduct,
    this.isSale = false,
  })  : assert(featuredProduct != null),
        assert(isSale != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              style: StyleList.smallBoldTextStyle.copyWith(
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        Text(
                          context.localizePrice(featuredProduct.price),
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
  }
}

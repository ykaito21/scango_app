import 'package:flutter/material.dart';
import '../../core/providers/app_providers/product_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import 'featured_product_card.dart';

class StoreProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchedProductList = context
        .provider<ProductProvider>(listen: true)
        .searchProductList(query);
    if (matchedProductList.isEmpty) {
      return Center(
          child: Container(
        child: Text(
          context.translate('noMatchedProduct'),
          style: StyleList.baseTitleTextStyle.copyWith(
              // color: context.accentColor,
              ),
        ),
      ));
    }
    return ListView.builder(
      itemCount: matchedProductList.length,
      itemBuilder: (context, index) {
        final matchedProduct = matchedProductList[index];
        final isSale = matchedProduct.price != matchedProduct.originalPrice;
        return FeaturedProductCard(
          featuredProduct: matchedProduct,
          isSale: isSale,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final featuredProductList =
        context.provider<ProductProvider>(listen: true).featuredProductList;
    final matchedProductList = context
        .provider<ProductProvider>(listen: true)
        .searchProductList(query);
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: featuredProductList.length,
        itemBuilder: (context, index) {
          final featuredProduct = featuredProductList[index];
          final isSale = featuredProduct.price != featuredProduct.originalPrice;
          return FeaturedProductCard(
            featuredProduct: featuredProduct,
            isSale: isSale,
          );
        },
      );
    }
    return ListView.builder(
      itemCount: matchedProductList.length,
      itemBuilder: (context, index) {
        final matchedProduct = matchedProductList[index];
        final isSale = matchedProduct.price != matchedProduct.originalPrice;
        return FeaturedProductCard(
          featuredProduct: matchedProduct,
          isSale: isSale,
        );
      },
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/providers/app_providers/promotion_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/cached_image.dart';

class PromotionSlider extends StatelessWidget {
  const PromotionSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promotionList =
        context.provider<PromotionProvider>(listen: true).promotionList;
    return Container(
      height: 250.0,
      child: promotionList.isEmpty
          // ? null
          ? CarouselSlider.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Shimmer.fromColors(
                  baseColor: context.accentColor.withOpacity(0.5),
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    height: 200.0,
                    color: context.accentColor.withOpacity(0.5),
                  ),
                );
              },
            )
          : CarouselSlider.builder(
              // enlargeCenterPage: true,
              itemCount: promotionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      print('touch');
                      // call and fetch promotion products
                      // navigate to new screen showing promotion products
                      // use image as hero and sliver appbar?
                    },
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        padding: StyleList.horizontalPadding5,
                        child: CachedImage(
                          imageUrl: promotionList[index].imageUrl,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

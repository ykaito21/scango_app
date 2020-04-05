import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/store_model.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../../core/providers/screen_providers/store_edit_screen_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../widgets/default_store_card.dart';
import '../widgets/recent_stores_card.dart';
import '../widgets/store_map_card.dart';
import '../widgets/store_tile.dart';

class StoreEditScreen extends StatelessWidget {
  const StoreEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* doesn't have to be proxyprovider
    //* could be just ChangeNotifierProvider(currentLocation: context.provider<StoreProvider>().currentLocation)
    return ChangeNotifierProxyProvider<StoreProvider, StoreEditScreenProvider>(
      create: (context) => StoreEditScreenProvider(),
      update: (context, storeProvider, storeEditScreenProvider) {
        storeEditScreenProvider.currentLocation = storeProvider.currentLocation;
        return storeEditScreenProvider;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.translate('editStore'),
            style: StyleList.baseSubtitleTextStyle,
          ),
        ),
        body: Padding(
          padding: StyleList.horizontalPadding10,
          child: Column(
            children: <Widget>[
              StoreMapCard(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Selector<StoreProvider, StoreModel>(
                          selector: (context, storeProvider) =>
                              storeProvider.store,
                          builder: (context, store, child) {
                            return StoreTile(
                              titleText: context.translate('currentStore'),
                              subtitleText: store.name,
                              onTap: null,
                            );
                          }),
                      //* search by keywords could be added
                      // StyleList.verticalBox20,
                      // BaseButton(
                      //   onPressed: () {},
                      //   buttonText: context.translate('search'),
                      // ),
                      StyleList.verticalBox10,
                      RecentStoresCard(),
                      StyleList.verticalBox10,
                      DefaultStoreCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

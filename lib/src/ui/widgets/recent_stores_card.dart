import 'package:flutter/material.dart';
import '../../core/providers/app_providers/auth_provider.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../global/constants.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';

class RecentStoresCard extends StatelessWidget {
  const RecentStoresCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.provider<StoreProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.translate('recentlyUsedStores'),
          style: StyleList.smallBoldTextStyle.copyWith(
            color: context.accentColor,
          ),
          textAlign: TextAlign.center,
        ),
        ...context.provider<AuthProvider>().user.recentStores.map(
              (store) => FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: storeProvider.store != store
                    ? () => Constants.onPressedNewStore(
                        context, storeProvider, store)
                    : null,
                child: Text(
                  store.name,
                  style: StyleList.smallBoldTextStyle.copyWith(
                    color: context.captionColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ],
    );
  }
}

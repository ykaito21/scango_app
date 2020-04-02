import 'package:flutter/material.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../global/extensions.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../widgets/store_tile.dart';

class DefaultStoreCard extends StatelessWidget {
  const DefaultStoreCard({Key key}) : super(key: key);

  Future<void> onTapDefault(
    BuildContext context,
    StoreProvider storeProvider,
  ) async {
    final confirmation = await PlatformAlertDialog(
      title: context.translate('setDefaultStore'),
      content: context.localizeAlertTtile(storeProvider.store.name, 'wantToSet',
          secondKey: 'asYourDefaultStore'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
    try {
      if (confirmation) {
        await storeProvider.changeDefaultStore(storeProvider.store);
      }
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.provider<StoreProvider>(listen: true);
    final defaultStore = storeProvider.defaultStore;
    return StoreTile(
      titleText: context.translate('currentDefaultStore'),
      subtitleText: defaultStore == null
          ? context.translate('setDefaultStore')
          : defaultStore.name,
      onTap: defaultStore != storeProvider.store
          ? () async => onTapDefault(context, storeProvider)
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/models/store_model.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import 'extensions.dart';

class Constants {
  static Future<void> onPressedNewStore(BuildContext context,
      StoreProvider storeProvider, StoreModel newStore) async {
    bool confirmationForDefault = false;
    final confirmation = await PlatformAlertDialog(
      title: context.translate('changeStore'),
      content: context.localizeAlertTtile(
          newStore.name, 'alertConfirmContentChangeStore'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
    if (confirmation) {
      storeProvider.chnageStore(newStore);
      if (storeProvider.defaultStore != newStore) {
        confirmationForDefault = await PlatformAlertDialog(
          title: context.translate('setDefaultStore'),
          content: context.localizeAlertTtile(
              storeProvider.store.name, 'wantToSet',
              secondKey: 'asYourDefaultStore'),
          defaultActionText: context.translate('yes'),
          cancelActionText: context.translate('cancel'),
        ).show(context);
      }
      try {
        if (confirmationForDefault) {
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
  }
}

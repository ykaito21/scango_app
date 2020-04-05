import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../core/models/store_model.dart';
import '../../core/providers/app_providers/store_provider.dart';
import '../../core/providers/screen_providers/store_edit_screen_provider.dart';
import '../global/constants.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_button.dart';
import '../shared/widgets/stream_wrapper.dart';

class StoreMapCard extends StatelessWidget {
  const StoreMapCard({Key key}) : super(key: key);

  Future<void> requestPermission(BuildContext context) async {
    await PlatformAlertDialog(
      title: context.translate('changeSettings'),
      content: context.translate('pleaseAllowAccess'),
      defaultActionText: 'OK',
    ).show(context);
    openAppSettings();
  }

  Future<void> onPressedButton(
      BuildContext context, StoreProvider storeProvider) async {
    final res = await Permission.location.status;
    if (res == PermissionStatus.denied) {
      requestPermission(context);
    } else {
      final storeEditScreenProvider =
          context.provider<StoreEditScreenProvider>();
      try {
        final position = await storeEditScreenProvider.getLocation();
        storeProvider.updateLocation(position);
        storeEditScreenProvider.mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 17.0,
            ),
          ),
        );
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.provider<StoreProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Consumer<StoreEditScreenProvider>(
          builder: (context, storeEditScreenProvider, child) {
            final tappedStore = storeEditScreenProvider.tappedStore;
            return Container(
              height: 300.0,
              child: Stack(
                children: <Widget>[
                  StreamWrapper<List<StoreModel>>(
                    stream: storeEditScreenProvider.streamMapStores,
                    onSuccess: (context, stores) {
                      return GoogleMap(
                        onMapCreated: (GoogleMapController controller) =>
                            storeEditScreenProvider.mapController = controller,
                        onTap: (latlng) =>
                            storeEditScreenProvider.tapStore(null),
                        initialCameraPosition: CameraPosition(
                          target: storeEditScreenProvider.currentMapLocation,
                          zoom: 17.0,
                        ),
                        markers: stores
                            .map(
                              (store) => Marker(
                                  markerId: MarkerId(store.id),
                                  icon: storeEditScreenProvider.pinLocationIcon,
                                  position: LatLng(
                                      store.position['geopoint'].latitude,
                                      store.position['geopoint'].longitude),
                                  onTap: () =>
                                      storeEditScreenProvider.tapStore(store)),
                            )
                            .toSet(),
                        onCameraMove: (position) => storeEditScreenProvider
                            .changeMapLocation(position.target),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment(0, 0.9),
                    child: tappedStore != null
                        ? Card(
                            child: InkWell(
                              onTap: storeProvider.store != tappedStore
                                  ? () => Constants.onPressedNewStore(
                                      context, storeProvider, tappedStore)
                                  : null,
                              child: Container(
                                padding: StyleList.allPadding10,
                                child: Text(
                                  tappedStore.name,
                                  style: StyleList.smallBoldTextStyle.copyWith(
                                    color: context.accentColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
        StyleList.verticalBox10,
        BaseButton(
          onPressed: () => onPressedButton(context, storeProvider),
          buttonText: context.translate('findByCurrentLocation'),
        ),
      ],
    );
  }
}

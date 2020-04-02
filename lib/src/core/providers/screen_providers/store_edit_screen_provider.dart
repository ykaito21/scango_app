import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/store_model.dart';
import '../../providers/base_provider.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';

class StoreEditScreenProvider extends BaseProvider {
  final _locationService = LocationService.instance;
  final _dbService = DatabaseService.instance;
  Position _currentLocation;
  final BehaviorSubject<LatLng> _mapLocationSubject =
      BehaviorSubject<LatLng>.seeded(LatLng(35.669860, 139.742690));
  LatLng get currentMapLocation => _mapLocationSubject.value;
  Function get changeMapLocation => _mapLocationSubject.add;
  final _mapStoresSubject = BehaviorSubject<List<StoreModel>>.seeded([]);
  Stream<List<StoreModel>> get streamMapStores => _mapStoresSubject.stream;
  GoogleMapController mapController;

  set currentLocation(Position value) {
    if (_currentLocation != value) {
      _currentLocation = value;
      if (_currentLocation != null) {
        changeMapLocation(
            LatLng(_currentLocation.latitude, _currentLocation.longitude));
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _mapLocationSubject.close();
    _mapStoresSubject.close();
    super.dispose();
  }

  BitmapDescriptor pinLocationIcon;
  StoreModel tappedStore;

  void tapStore(StoreModel newStore) {
    if (tappedStore != newStore) {
      tappedStore = newStore;
      notifyListeners();
    }
  }

  Future<void> setCustomMapPin() async {
    //! cannt change icon size
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(1.0, 1.0)),
      'assets/images/pin.png',
    );
    notifyListeners();
  }

  Future<Position> getLocation() async {
    final res = await _locationService.getCurrentLocation();
    if (res != null) {
      return res;
    } else {
      throw PlatformException(
        code: 'ERROR_DISABLED',
      );
    }
  }

  StoreEditScreenProvider() {
    setCustomMapPin();
    _mapLocationSubject
        .debounceTime(Duration(milliseconds: 500))
        .map((latlong) => _locationService.geoFire
            .point(latitude: latlong.latitude, longitude: latlong.longitude))
        .switchMap((center) {
      return _locationService.geoFire
          .collection(
              collectionRef: _dbService.getCollectionReference('stores'))
          .within(center: center, radius: 0.1, field: 'position');
    }).listen((data) {
      final storeData = data
          .map((doc) => StoreModel.fromFirestore(doc.data, doc.documentID))
          .toList();
      _mapStoresSubject.add(storeData);
    });
  }
}

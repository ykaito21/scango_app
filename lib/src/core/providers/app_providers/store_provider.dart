import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/store_model.dart';
import '../../services/api_path.dart';
import '../../services/database_service.dart';
import '../../services/secrets.dart';
import '../../services/location_service.dart';
import '../base_provider.dart';

class StoreProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  final _locationService = LocationService.instance;
  StoreModel _sampleStore;
  StoreModel _store;
  List<StoreModel> _stores = [];
  StoreModel get store => _store;
  List<StoreModel> get stores => [..._stores];

  // default store
  StoreModel _defaultStore;
  StoreModel get defaultStore => _defaultStore;

  // location
  Position _currentLocation;
  Position get currentLocation => _currentLocation;

  void _setStore(StoreModel value) {
    if (_store != value) {
      _store = value;
      notifyListeners();
    }
  }

  StoreProvider() {
    initStore();
  }

  Future<void> initStore() async {
    _currentLocation = await _locationService.getCurrentLocation();
    await getDefaultStore();
    getStore(_currentLocation);
  }

  Future<void> getDefaultStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultStoreId = prefs.getString('defaultStoreId');
      if (defaultStoreId != null) {
        //! need to check doc is not null
        final doc = await _dbService.getDocumentById(
            path: ApiPath.store(defaultStoreId));
        _defaultStore = StoreModel.fromFirestore(doc.data, doc.documentID);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeDefaultStore(StoreModel newDefault) async {
    _defaultStore = newDefault;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('defaultStoreId', _defaultStore.id);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> getSampleStore() async {
    try {
      //! need to check doc is not null
      final doc = await _dbService.getDocumentById(
          path: ApiPath.store(Secrets.defaultStoreId));
      final sampleStore = StoreModel.fromFirestore(doc.data, doc.documentID);
      if (sampleStore != null) _sampleStore = sampleStore;
    } catch (e) {
      print(e);
    }
  }

  Future<void> initStoreWithoutPosition() async {
    if (_defaultStore != null) {
      _setStore(_defaultStore);
    } else {
      await getSampleStore();
      //* need to avoid no store
      //  _sampleStore = StoreModel(id: '', name: '', brand: '', category: '', position: {});
      _setStore(_sampleStore);
    }
  }

  Stream<List<DocumentSnapshot>> _streamStores(GeoFirePoint center) {
    return _locationService.geoFire
        .collection(collectionRef: _dbService.getCollectionReference('stores'))
        .within(center: center, radius: 0.1, field: 'position');
  }

  Future<void> getStore(Position position) async {
    if (position != null) {
      final center = _locationService.geoFire
          .point(latitude: position.latitude, longitude: position.longitude);
      final res = await _streamStores(center).first.catchError((e) {
        print(e);
        return [];
      });
      final storeData = res
          .map((doc) => StoreModel.fromFirestore(doc.data, doc.documentID))
          .toList();
      _stores = storeData;
      if (stores.isNotEmpty) {
        _setStore(storeData.first);
      } else {
        initStoreWithoutPosition();
      }
      //* with stream subscription
      // StreamSubscription<List<DocumentSnapshot>> streamDocs;
      // streamDocs = _geoFire
      //     .collection(
      //         collectionRef: _dbService.getCollectionReference('stores'))
      //     .within(center: center, radius: 0.1, field: 'position')
      //     .listen((res) {
      //   final storeData = res
      //       .map((doc) => StoreModel.fromFirestore(doc.data, doc.documentID))
      //       .toList();
      //   _stores = storeData;
      //   if (stores.isNotEmpty) {
      //     _setStore(storeData.first);
      //   } else {
      //    initStoreWithoutPosition();
      //   }
      //   streamDocs.cancel();
      // });
    } else {
      initStoreWithoutPosition();
    }
  }

  void chnageStore(StoreModel newStore) {
    _setStore(newStore);
  }

  void updateLocation(Position newPosition) {
    // don't need notifyListeners
    _currentLocation = newPosition;
  }
}

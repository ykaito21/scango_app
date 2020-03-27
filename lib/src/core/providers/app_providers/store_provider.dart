import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/store_model.dart';
import '../../services/api_path.dart';
import '../../services/database_service.dart';
import '../../services/secrets.dart';
import '../base_provider.dart';

class StoreProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  final _geolocator = Geolocator();
  final _geoFire = Geoflutterfire();
  StoreModel _sampleStore =
      StoreModel(id: '', name: '', brand: '', category: '', position: {});
  StoreModel _store;
  List<StoreModel> _stores = [];
  StoreModel get store => _store;
  List<StoreModel> get stores => [..._stores];

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
    await getSampleStore();
    final currentLocation = await _getCurrentLocation();
    getStore(currentLocation);
  }

  Future<Position> _getCurrentLocation() async {
    try {
      return await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> getSampleStore() async {
    try {
      final doc = await _dbService.getDocumentById(
          path: ApiPath.store(Secrets.defaultStoreId));
      _sampleStore = StoreModel.fromFirestore(doc.data, doc.documentID);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStore(Position position) async {
    if (position != null) {
      final center = _geoFire.point(
          latitude: position.latitude, longitude: position.longitude);
      final res = await _geoFire
          .collection(
              collectionRef: _dbService.getCollectionReference('stores'))
          .within(center: center, radius: 0.1, field: 'position')
          .first
          .catchError((e) {
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
        _setStore(_sampleStore);
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
      //     _setStore(sampleStore);
      //   }
      //   streamDocs.cancel();
      // });
    } else {
      _setStore(_sampleStore);
    }
  }
}

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';
import '../models/store_model.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';
import '../services/secrets.dart';

import 'base_provider.dart';

class StoreProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  final _geolocator = Geolocator();
  final _geoFire = Geoflutterfire();

  final _storesSubject = BehaviorSubject<List<StoreModel>>.seeded([]);
  Stream<List<StoreModel>> get streamStores => _storesSubject.stream;

  StoreProvider() {
    initStore();
  }

  @override
  void dispose() {
    _storesSubject.close();
    super.dispose();
  }

  Future<void> initStore() async {
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

  Future<void> getStore(Position position) async {
    final doc = await _dbService.getDocumentById(
        path: ApiPath.store(Secrets.defaultStoreId));
    final defaultStore = StoreModel.fromFirestore(doc.data, doc.documentID);
    if (position != null) {
      final center = _geoFire.point(latitude: 35.68173, longitude: 139.766185);
      final res = _geoFire
          .collection(
              collectionRef: _dbService.getCollectionReference('stores'))
          .within(center: center, radius: 0.1, field: 'position');
      final storeData = res.map((list) => list
          .map((doc) => StoreModel.fromFirestore(doc.data, doc.documentID))
          .toList());
      storeData.listen((List<StoreModel> stores) {
        if (stores.isNotEmpty) {
          _storesSubject.add(stores);
        } else {
          _storesSubject.add([defaultStore]);
        }
      });
    } else {
      _storesSubject.add([defaultStore]);
    }
  }
}

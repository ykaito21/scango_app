import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../providers/base_provider.dart';
import '../../services/api_path.dart';
import '../../services/database_service.dart';

class ProductProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  StoreModel _currentStore;
  List<ProductModel> _featuredProductList = [];
  List<ProductModel> get featuredProductList => [..._featuredProductList];

  set currentStore(StoreModel value) {
    if (_currentStore != value) {
      _currentStore = value;
      if (_currentStore != null) {
        fetchFeaturedProductList();
      }
    }
  }

  Future<void> fetchFeaturedProductList() async {
    try {
      final res = await _dbService.getDataCollection(
          path: ApiPath.storeFeaturedProducts(_currentStore.id));
      final productList = res.documents.map((doc) {
        return ProductModel.fromFirestore(doc.data, doc.documentID);
      }).toList();
      _featuredProductList = productList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

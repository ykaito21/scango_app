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

  List<ProductModel> searchProductList(String query) {
    //* could be adding search from all products with keyword subject, switchMap and stream
    List<ProductModel> matchedProductList = [];
    final keywords = query.split(RegExp('\\s+'));
    print(keywords);
    keywords.removeWhere((keyword) => keyword.isEmpty);
    for (ProductModel product in _featuredProductList) {
      if (keywords.any((keyword) => product.name.contains(keyword)) ||
          keywords.any((keyword) => product.description.contains(keyword))) {
        matchedProductList.add(product);
      }
    }
    return matchedProductList;
  }
}

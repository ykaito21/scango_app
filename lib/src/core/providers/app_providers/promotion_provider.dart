// import '../../models/product_model.dart';
import '../../models/promotion_model.dart';
import '../../models/store_model.dart';
import '../../services/api_path.dart';
import '../../services/database_service.dart';

import '../base_provider.dart';

class PromotionProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  StoreModel _currentStore;
  List<PromotionModel> _promotionList = [];
  List<PromotionModel> get promotionList => [..._promotionList];
  // List<ProductModel> _promotionProductList = [];
  // List<ProductModel> get promotionProductList => [..._promotionProductList];

  set currentStore(StoreModel value) {
    if (_currentStore != value) {
      _currentStore = value;
      if (_currentStore != null) {
        fetchPromotionList();
      }
    }
  }

  Future<void> fetchPromotionList() async {
    try {
      final res = await _dbService.getDataCollection(
          path: ApiPath.storePromotions(_currentStore.id));
      final promotionList = res.documents.map((doc) {
        return PromotionModel.fromFirestore(doc.data, doc.documentID);
      }).toList();
      _promotionList = promotionList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

// could be screen provider
  // Future<void> fetchPromotionProductList(PromotionModel promotion) async {
  //   try {
  //     final res = await _dbService.getDataCollection(
  //         path: ApiPath.storePromotionProducts(_currentStore.id, promotion.id));
  //     final productList = res.documents.map((doc) {
  //       return ProductModel.fromFirestore(doc.data, doc.documentID);
  //     }).toList();
  //     _promotionProductList = productList;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

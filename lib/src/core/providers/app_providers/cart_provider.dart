import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:scango_app/src/core/models/store_model.dart';
import 'package:scango_app/src/core/models/user_model.dart';
import '../../models/cart_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import '../../services/api_path.dart';
import '../base_provider.dart';

class CartProvider extends BaseProvider {
  UserModel _currentUser;
  StoreModel _currentStore;
  final _dbService = DatabaseService.instance;
  final _cartSubject = BehaviorSubject<List<CartModel>>.seeded([]);
  final random = Random();
  Stream<List<CartModel>> get streamCart => _cartSubject.stream;
  List<CartModel> get cart => _cartSubject.value;

  set currentUser(UserModel value) {
    if (_currentUser != value) {
      _currentUser = value;
      _initCart();
    }
  }

  set currentStore(StoreModel value) {
    if (_currentStore != value) {
      _currentStore = value;
      _initCart();
    }
  }

  @override
  dispose() {
    _cartSubject.close();
    super.dispose();
  }

  int totalPrice() {
    return cart.fold(
      0,
      (total, item) => total + (item.quantity * item.productItem.price),
    );
  }

  int totalQuantity() {
    return cart.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  void _initCart() {
    if (_currentUser != null && _currentStore != null) {
      _streamCart()
          .listen(_cartSubject.add)
          .onError((error) => _cartSubject.add([]));
    } else {
      _cartSubject.add([]);
    }
  }

  Stream<List<CartModel>> _streamCart() {
    final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
      path: ApiPath.storeCart(_currentUser.id, _currentStore.id),
      orderBy: 'createdAt',
      descending: true,
    );
    return res.map(
      (list) {
        final List<CartModel> cart = list.documents
            .map(
              (doc) => CartModel.fromFirestore(doc.data, doc.documentID),
            )
            .toList();
        return cart;
      },
    );
  }

  Future<void> addCartItem(
      {@required ProductModel productItem, @required int quantity}) async {
    final checkProduct =
        cart.where((cartItem) => cartItem.productItem == productItem);
    try {
      if (checkProduct.isEmpty) {
        final newCartItem = CartModel(
          id: 'NEW_ITEM',
          quantity: quantity,
          productItem: productItem,
        );
        await _dbService.addDocument(
          path: ApiPath.storeCart(_currentUser.id, _currentStore.id),
          data: newCartItem.toMapForeFirestore(),
        );
      } else {
        final existingCartItem = checkProduct.first;
        await _dbService.updateDocument(
          path: ApiPath.storeCartItem(
              _currentUser.id, _currentStore.id, existingCartItem.id),
          data: {
            "quantity": existingCartItem.quantity + quantity,
          },
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateCartItem({
    @required CartModel cartItem,
    @required bool isIncrement,
  }) async {
    try {
      if (isIncrement) {
        await _dbService.updateDocument(
          path: ApiPath.storeCartItem(
              _currentUser.id, _currentStore.id, cartItem.id),
          data: {
            "quantity": FieldValue.increment(1),
          },
        );
      } else {
        await _dbService.updateDocument(
          path: ApiPath.storeCartItem(
              _currentUser.id, _currentStore.id, cartItem.id),
          data: {
            "quantity": FieldValue.increment(-1),
          },
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeCartItem(CartModel cartItem) async {
    try {
      await _dbService.removeDocument(
        path: ApiPath.storeCartItem(
            _currentUser.id, _currentStore.id, cartItem.id),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

//* can be improve to use transaction and batch
  Future<int> convertToOrder() async {
    setViewState(ViewState.Busy);
    final code = random.nextInt(9000) + 1000;
    final newOrder = OrderModel(
      id: 'NEW_ORDER',
      price: totalPrice(),
      quantity: totalQuantity(),
      code: code.toString(),
      date: DateTime.now(),
      status: 'PENDING',
      cart: cart,
    );
    try {
      // add order
      await _dbService.addDocument(
        path: ApiPath.storeOrders(_currentUser.id, _currentStore.id),
        data: newOrder.toMapForFirestore(),
      );
      // get all cart items path
      final pathList = cart
          .map((cartItem) => ApiPath.storeCartItem(
              _currentUser.id, _currentStore.id, cartItem.id))
          .toList();
      // remove all cart items with transaction
      await _dbService.removeAllDocument(pathList: pathList);
      setViewState(ViewState.Retrieved);
      return code;
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }
}

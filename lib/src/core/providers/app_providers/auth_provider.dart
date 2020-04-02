import 'package:firebase_auth/firebase_auth.dart';
import 'package:scango_app/src/core/models/user_model.dart';
import 'package:scango_app/src/core/providers/base_provider.dart';
import 'package:scango_app/src/core/services/api_path.dart';
import 'package:scango_app/src/core/services/database_service.dart';
import '../../services/auth_service.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends BaseProvider {
  final _auth = FirebaseAuth.instance;
  final _authService = AuthService.instance;
  final _dbService = DatabaseService.instance;
  UserModel _user;
  Status _status = Status.Uninitialized;
  UserModel get user => _user;
  Status get status => _status;
  bool get isUninitialized => _status == Status.Uninitialized;
  bool get isAuthenticated => _status == Status.Authenticated;
  bool get isUnauthenticated => _status == Status.Unauthenticated;

  AuthProvider() {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    try {
      if (firebaseUser == null) {
        _user = null;
        _status = Status.Unauthenticated;
      } else {
        final doc = await _dbService.getDocumentById(
          path: ApiPath.user(firebaseUser.uid),
        );
        //! this way can't detect user model update without refresh
        _user = UserModel.fromFirestore(doc.data, doc.documentID);
        _status = Status.Authenticated;
      }
      notifyListeners();
      print(_user);
      print(_status);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

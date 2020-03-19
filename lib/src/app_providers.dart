import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/providers/auth_provider.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
  ...uiProviders,
];

List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider<AuthProvider>(
    create: (_) => AuthProvider(),
  ),
];

List<SingleChildWidget> dependentProviders = [];

List<SingleChildWidget> uiProviders = [];

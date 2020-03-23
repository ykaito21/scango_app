// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:scango_app/src/core/providers/auth_provider.dart';
// import 'package:scango_app/src/ui/screens/home_screen.dart';

// import 'auth_screen.dart';

// class InitialScreen extends StatelessWidget {
//   const InitialScreen({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         if (authProvider.isUnauthenticated) return AuthScreen();
//         if (authProvider.isAuthenticated) {
//           //* can be require user info, payment info, and selected store with new screen
//           // if (authProvider.user.firstName.isEmpty ||
//           //     authProvider.user.firstName.isEmpty)
//           //     return NewScreen();
//           return HomeScreen();
//         }
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }

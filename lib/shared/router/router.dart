import 'package:flutter/material.dart';
import 'package:net4moly/Screens/admin/admin_home_screen.dart';
import 'package:net4moly/Screens/authentication/signin/sign_in.dart';
import 'package:net4moly/Screens/splash_screen/splash_screen.dart';
import 'package:net4moly/Screens/user/user_home_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/signin':
        return MaterialPageRoute(builder: (_) => Signin());
      case '/user':
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminHomeScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

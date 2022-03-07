import 'package:flutter/material.dart';

import '../page/cart/cart_page.dart';
import '../page/product_detail/product_detail_page.dart';
import '../page/product_list/product_list_page.dart';

// ignore: avoid_classes_with_only_static_members
class RouteGenerator {
  static const String home = '/home';
  static const String detail = '/detail';
  static const String cart = '/cart';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return buildRoute(ProductListPage(), settings: settings);
      case detail:
        return buildRoute(ProductDetailWidget(settings.arguments), settings: settings);
      case cart:
        return buildRoute(CartPage(), settings: settings);
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute<dynamic> buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute<dynamic>(
        settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'ERROR!!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  "Seems the route you've navigated to doesn't exist!!",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

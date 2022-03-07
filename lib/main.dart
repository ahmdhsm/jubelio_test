import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/route_generator.dart';
import 'page/product_list/product_list_page.dart';

final ProviderContainer providerContainer = ProviderContainer();

Future<void> main() async {
  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jubelio Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jubelio_test/main.dart';
import 'package:jubelio_test/page/product_list/product_list_page.dart';

Future<void> main() async {
  group('Counter', () {
    testWidgets('Widget has cart button', (WidgetTester tester) async {
      // UncontrolledProviderScope(
      //   container: providerContainer,
      //   child: MaterialApp(home: ProductListPage()),
      // );
      await tester.pumpWidget(UncontrolledProviderScope(
        container: providerContainer,
        child: MaterialApp(home: ProductListPage()),
      ));

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      final Finder appTitle = find.text('List Product');
      final Finder cartButton = find.byIcon(FontAwesomeIcons.shoppingCart);

      expect(appTitle, findsOneWidget);
      expect(cartButton, findsOneWidget);
    });
  });
}

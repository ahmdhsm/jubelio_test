import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/constants.dart';
import '../../config/route_generator.dart';
import '../../page/product_list/product_card_widget.dart';

import 'product_list_controller.dart';

final ChangeNotifierProviderFamily<ProductListController, ProductListController> productListNotifierProvider =
    ChangeNotifierProvider.family<ProductListController, ProductListController>(
        (ChangeNotifierProviderRef<ProductListController> ref, ProductListController productListController) {
  return productListController;
});

// ignore: must_be_immutable
class ProductListPage extends ConsumerWidget {
  ProductListPage({Key? key}) : super(key: key);

  ProductListController productListController = ProductListController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductListController _productListProvider =
        ref.watch(productListNotifierProvider(productListController));
    return Scaffold(
      appBar: AppBar(
        title: _productListProvider.searchShow == true
            ? textBox(_productListProvider)
            : const Text('List Product'),
        backgroundColor: HEADER_COLOR,
        actions: _productListProvider.searchShow == true
            ? null
            : <Widget>[
                InkWell(
                  onTap: _productListProvider.showSearchBar,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(FontAwesomeIcons.search),
                  ),
                ),
              ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.metrics.atEdge) {
            if (notification.metrics.pixels != 0) {
              _productListProvider.loadNewData();
            }
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _productListProvider.productListFiltered.length,
          itemBuilder: (BuildContext context, int index) {
            final ElevaniaProductModel currrentProduct =
                _productListProvider.productListFiltered[index];
            return ProductCardWidget(_productListProvider, currrentProduct);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.cart,
          ).then(
            (Object? value) => _productListProvider.refreshCart(),
          );
        },
        backgroundColor: BUTTON_COLOR,
        child: const Icon(FontAwesomeIcons.shoppingCart),
      ),
    );
  }

  Widget textBox(ProductListController productListProvider) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (String keyword) {
        productListProvider.search(keyword);
      },
      decoration: InputDecoration(
        hintText: 'Cari nama barang ...',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: InkWell(
          onTap: productListProvider.hideSearchBar,
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        border: InputBorder.none,
      ),
    );
  }
}

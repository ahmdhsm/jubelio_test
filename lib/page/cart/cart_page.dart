import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../page/cart/cart_card_widget.dart';
import '../../page/cart/cart_controller.dart';

final ChangeNotifierProviderFamily<CartController, CartController>
    cartNotifierProvider =
    ChangeNotifierProvider.family<CartController, CartController>(
        (ChangeNotifierProviderRef<CartController> ref,
            CartController cartController,) {
  return cartController;
});

// ignore: must_be_immutable
class CartPage extends ConsumerWidget {
  CartPage({Key? key}) : super(key: key);

  CartController cartController = CartController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CartController _cartProvider =
        ref.watch(cartNotifierProvider(cartController));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: HEADER_COLOR,
      ),
      body: _cartProvider.cartList.isEmpty
          ? const Center(child: Text('Tidak ada product'))
          : ListView.builder(
              itemCount: _cartProvider.cartList.length,
              itemBuilder: (BuildContext context, int index) {
                return CartCardWidget(
                  _cartProvider,
                  _cartProvider.cartList[index],
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../service/cart/cart.dart';
import '../../service/elevania/elevania.dart';
import '../../service/product/product.dart';

class CartController extends ChangeNotifier {
  CartController() {
    init();
  }

  Map<int, ElevaniaProductModel> productList = <int, ElevaniaProductModel>{};
  List<CartProductModel> cartList = <CartProductModel>[];
  
  ProductService<ElevaniaProductModel> elevaniaService =
      ProductService<ElevaniaProductModel>(ElevaniaProductModel());
  
  CartService cartService = CartService();

  Future<void> init() async {
    await getAllData();
    await getAllCart();
    notifyListeners();
  }

  Future<void> getAllData() async {
    final List<ElevaniaProductModel> tempProductList =
        await elevaniaService.getOfflineData(0);
    for (final ElevaniaProductModel item in tempProductList) {
      productList[item.productCode] = item;
    }
  }

  Future<void> getAllCart() async {
    final Map<int, CartProductModel> tempCartList =
        await cartService.getAllCart();
    for (final CartProductModel item in tempCartList.values) {
      if (item.productQty > 0 && productList.containsKey(item.productCode)) {
        cartList.add(item);
      }
    }
  }

  Future<void> minQty(CartProductModel cart) async {
    final ElevaniaProductModel? tempProduct = productList[cart.productCode];

    if (cart.productQty <= 0) {
      return;
    }

    final int indexCart = cartList.indexWhere(
        (CartProductModel element) => element.productCode == cart.productCode);

    cart.productQty -= 1;
    cartList[indexCart] = cart;

    await cartService.editCart(tempProduct!, cart.productQty);
    notifyListeners();
  }

  Future<void> addQty(CartProductModel cart) async {
    final ElevaniaProductModel? tempProduct = productList[cart.productCode];

    if (cart.productQty >= tempProduct!.productSellQty) {
      return;
    }

    final int indexCart = cartList.indexWhere(
        (CartProductModel element) => element.productCode == cart.productCode);

    cart.productQty += 1;
    cartList[indexCart] = cart;

    await cartService.editCart(tempProduct, cart.productQty);
    notifyListeners();
  }
}

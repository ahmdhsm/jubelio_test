import 'package:flutter/material.dart';

import '../../service/cart/cart.dart';
import '../../service/elevania/elevania.dart';
import '../../service/product/product.dart';

export '../../service/cart/cart.dart';
export '../../service/elevania/elevania.dart';

class ProductListController extends ChangeNotifier {
  ProductListController() {
    init();
  }

  List<ElevaniaProductModel> productList = <ElevaniaProductModel>[];
  List<ElevaniaProductModel> productListFiltered = <ElevaniaProductModel>[];
  
  Map<int, CartProductModel> cartList = <int, CartProductModel>{};
  
  ProductService<ElevaniaProductModel> elevaniaService =
      ProductService<ElevaniaProductModel>(ElevaniaProductModel());
  
  CartService cartService = CartService();
  bool searchShow = false;
  int currentPage = 1;
  DateTime lastTime = DateTime.now();

  Future<void> init() async {
    await getAllData();
    await getAllCart();
    productListFiltered = productList;
    notifyListeners();
    downloadAllImage();
  }

  Future<void> loadNewData() async {
    final DateTimeRange range = DateTimeRange(start: lastTime, end: DateTime.now());
    if (range.duration.inSeconds < 1) {
      return;
    }
    if (productList.length != productListFiltered.length) {
      return;
    }
    currentPage += 1;
    lastTime = DateTime.now();
    await getAllData();
    await getAllCart();
    productListFiltered = productList;
    notifyListeners();
  }

  Future<void> search(String keyword) async {
    productListFiltered = productList
        .where((ElevaniaProductModel element) =>
            element.productName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void showSearchBar() {
    searchShow = true;
    notifyListeners();
  }

  Future<void> hideSearchBar() async {
    searchShow = false;
    await search('');
    notifyListeners();
  }

  Future<void> getAllData() async {
    productList.addAll(await elevaniaService.getOnlineData(currentPage));
  }

  Future<void> getAllCart() async {
    cartList = await cartService.getAllCart();
    for (final ElevaniaProductModel item in productList) {
      if (!cartList.containsKey(item.productCode)) {
        final CartProductModel tempCart = CartProductModel();
        tempCart.productCode = item.productCode;
        tempCart.productName = item.productName;
        tempCart.productQty = 0;
        cartList[item.productCode] = tempCart;
      }
    }
  }

  Future<void> refreshCart() async {
    await getAllCart();
    notifyListeners();
  }

  Future<void> downloadAllImage() async {
    for (int i = 0; i < productList.length; i++) {
      productList[i] = await elevaniaService.getDetail<ElevaniaProductModel>(productList[i]);
      final int currentProductShowIndex = productListFiltered.indexWhere((ElevaniaProductModel element) => element.productCode == productList[i].productCode);
      if (currentProductShowIndex != -1) {
        productListFiltered[currentProductShowIndex] = productList[i];
        notifyListeners();
      }
    }
  }

  Future<void> addQty(ProductModel currentProduct) async {
    final CartProductModel? tempCart = cartList[currentProduct.productCode];

    if (tempCart!.productQty >= currentProduct.productSellQty) {
      return;
    }

    tempCart.productQty += 1;
    cartList[currentProduct.productCode] = tempCart;
    await cartService.editCart(currentProduct, tempCart.productQty);
    notifyListeners();
  }

  Future<void> minQty(ProductModel currentProduct) async {
    final CartProductModel? tempCart = cartList[currentProduct.productCode];

    if (tempCart!.productQty <= 0) {
      return;
    }

    tempCart.productQty -= 1;
    cartList[currentProduct.productCode] = tempCart;
    await cartService.editCart(currentProduct, tempCart.productQty);
    notifyListeners();
  }
}

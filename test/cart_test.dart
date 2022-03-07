import 'package:flutter_test/flutter_test.dart';
import 'package:jubelio_test/page/product_list/product_list_controller.dart';

Future<void> main() async {
  final ProductListController productController = ProductListController();
  await productController.init();
  final ElevaniaProductModel firstProduct = productController.productList.first;

  const int qtyAdd = 10;
  const int qtyMinus = 5;

  // function to reset cart
  for (int i = 0; i < (firstProduct.productSellQty + 10); i++) {
    await productController.minQty(firstProduct);
  }

  group('Counter', () {
    test('Cart should start with 0', () async {
      final CartProductModel? cartProduct =
          productController.cartList[firstProduct.productCode];
      expect(cartProduct?.productQty, 0);
    });

    test('Increase cart x time', () async {
      final CartProductModel? cartProduct =
          productController.cartList[firstProduct.productCode];
      for (int i = 0; i < qtyAdd; i++) {
        await productController.addQty(firstProduct);
      }
      expect(
        cartProduct?.productQty,
        qtyAdd < firstProduct.productSellQty
            ? qtyAdd
            : firstProduct.productSellQty,
      );
    });

    test('Cart cannot be negative', () async {
      final CartProductModel? cartProduct =
          productController.cartList[firstProduct.productCode];
      for (int i = 0; i < (firstProduct.productSellQty + 10); i++) {
        await productController.minQty(firstProduct);
      }
      expect(cartProduct?.productQty, 0);
    });

    test('Cart cannot more than stock', () async {
      final CartProductModel? cartProduct =
          productController.cartList[firstProduct.productCode];
      for (int i = 0; i < (firstProduct.productSellQty + 10); i++) {
        await productController.addQty(firstProduct);
      }
      expect(cartProduct?.productQty, firstProduct.productSellQty);
    });

    test('Decrease cart x time', () async {
      final CartProductModel? cartProduct =
          productController.cartList[firstProduct.productCode];
      for (int i = 0; i < qtyMinus; i++) {
        await productController.minQty(firstProduct);
      }
      expect(
        cartProduct?.productQty,
        qtyMinus < firstProduct.productSellQty
            ? (firstProduct.productSellQty - qtyMinus)
            : 0,
      );
    });
  });
}

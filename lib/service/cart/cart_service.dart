import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../product/product.dart';
import 'cart.dart';

class CartService {
  List<CartProductModel> listCart = <CartProductModel>[];
  final String boxName = 'cart';
  late Box<dynamic> box;
  CartProductModel cartModel = CartProductModel();

  Future<void> init() async {
    final Directory path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  Future<Map<int, CartProductModel>> getAllCart() async {
    await init();
    final Map<int, CartProductModel> tempCartList = <int, CartProductModel>{};
   
    box = await Hive.openBox(boxName);
    // await box.clear();
    for (final dynamic item in box.values) {
      final CartProductModel currentCartModel = CartProductModel();
      final Map<String, dynamic> cartItem = Map<String, dynamic>.from(item as Map<dynamic, dynamic>);
      final CartProductModel cart = currentCartModel.jsonToModel(cartItem);
      tempCartList[cart.productCode] = cart;
    }
    return tempCartList;
  }

  Future<void> editCart(ProductModel product, int qty) async {
    await init();
    box = await Hive.openBox(boxName);
    
    if (qty <= 0) {
      box.delete(product.productCode);
    }

    final CartProductModel currentCartModel = CartProductModel();
    currentCartModel.productCode = product.productCode;
    currentCartModel.productName = product.productName;
    currentCartModel.productQty = qty;
    currentCartModel.productPrice = 0;
    currentCartModel.productStock = 0;

    box.put(product.productCode, currentCartModel.modelToJson(currentCartModel));
  }
}

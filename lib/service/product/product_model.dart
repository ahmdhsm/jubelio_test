import 'package:dio/dio.dart';

import 'product.dart';

abstract class ProductModel {
  late String mainURL;
  late String productListURL;
  late String productDetailURL;

  late int productCode;
  late String productName;
  late int productSellQty;
  late int productSellPrice;
  late List<String> imageURL;
  late ProductSource offlineSource;
  late ProductSource onlineSource;

  Future<List<ProductModel>> responseToListModel(Response<dynamic> response);

  Map<String, dynamic> modelToJson(ProductModel model);
  
  ProductModel jsonToModel(Map<String, dynamic> json);

  ProductModel responseToModel(Response<dynamic> response);

  String urlDetailBuilder();

  String urlListBuilder(int currentPage);
}

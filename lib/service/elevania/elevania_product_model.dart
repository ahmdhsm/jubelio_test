import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:xml2json/xml2json.dart';

import '../../config/constants.dart';
import '../../service/dio_source/dio_source.dart';
import '../../service/hive_source/hive.dart';
import '../../service/product/product.dart';

class ElevaniaProductModel implements ProductModel {
  ElevaniaProductModel() {
    offlineSource = HiveSourceService(ELEVANIA_HIVE);
    onlineSource = DioSourceService(<String, dynamic>{
      'openapikey': ELEVANIA_PRODUCT_KEY,
    });
  }

  @override
  String mainURL = ELEVANIA_MAIN_URL;

  @override
  String productDetailURL = ELEVANIA_PRODUCT_DETAIL_URL;

  @override
  String productListURL = ELEVANIA_PRODUCT_LIST_URL;

  @override
  late int productCode;

  @override
  late String productName;

  @override
  late int productSellQty;

  @override
  late int productSellPrice;

  @override
  List<String> imageURL = <String>[];

  @override
  late ProductSource offlineSource;

  @override
  late ProductSource onlineSource;

  @override
  Future<List<ElevaniaProductModel>> responseToListModel(
      Response<dynamic> response) async {
    final Xml2Json xmlToJson = Xml2Json();
    xmlToJson.parse(response.data.toString());

    final String stringParse = xmlToJson.toParker();

    final Map<String, dynamic> json =
        jsonDecode(stringParse) as Map<String, dynamic>;

    final List<ElevaniaProductModel> productList = <ElevaniaProductModel>[];

    // ignore: avoid_dynamic_calls
    for (final Map<String, dynamic> item in json['Products']['product']) {
      final ElevaniaProductModel product =
          ElevaniaProductModel().jsonResponseToModel(item);

      productList.add(product);
    }
    return productList;
  }

  @override
  ElevaniaProductModel jsonToModel(Map<String, dynamic> json) {
    final ElevaniaProductModel product = ElevaniaProductModel();
    product.productCode = int.parse((json['ProductCode'] ?? 0).toString());
    product.productName = (json['ProductName'] ?? '') as String;
    product.productSellQty =
        int.parse((json['ProductSellQty'] ?? 0).toString());
    product.productSellPrice =
        int.parse((json['ProductSellPrice'] ?? 0).toString());
    product.imageURL = json['ImageURL'] as List<String>;
    return product;
  }

  @override
  Map<String, dynamic> modelToJson(ProductModel model) {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['ProductCode'] = model.productCode;
    json['ProductName'] = model.productName;
    json['ProductSellQty'] = model.productSellQty;
    json['ProductSellPrice'] = model.productSellPrice;
    json['ImageURL'] = model.imageURL;
    return json;
  }

  ElevaniaProductModel jsonResponseToModel(Map<String, dynamic> json) {
    productCode = int.parse((json['prdNo'] ?? 0).toString());
    productName = (json['prdNm'] ?? '') as String;
    productSellQty = int.parse((json['prdSelQty'] ?? 0).toString());
    productSellPrice = int.parse((json['selPrc'] ?? 0).toString());
    if (json.containsKey('prdImage01')) {
      if (imageURL.isNotEmpty) {
        imageURL.clear();
      }
    }
    for (int i = 0; i < 10; i++) {
      final String currentKey = 'prdImage${i.toString().padLeft(2, "0")}';
      if (json.containsKey(currentKey)) {
        imageURL.add((json[currentKey] ?? '').toString());
      } else {
        continue;
      }
    }
    return this;
  }

  @override
  ProductModel responseToModel(dynamic response) {
    response = response as Response<dynamic>;
    final Xml2Json xmlToJson = Xml2Json();
    xmlToJson.parse(response.data.toString());

    final String stringParse = xmlToJson.toParker();

    final Map<String, dynamic> json =
        jsonDecode(stringParse) as Map<String, dynamic>;

    final ElevaniaProductModel product = ElevaniaProductModel()
        .jsonResponseToModel(json['Product'] as Map<String, dynamic>);

    return product;
  }

  @override
  String urlDetailBuilder() {
    return ELEVANIA_MAIN_URL +
        ELEVANIA_PRODUCT_DETAIL_URL +
        productCode.toString();
  }

  @override
  String urlListBuilder(int currentPage) {
    return '$ELEVANIA_MAIN_URL$ELEVANIA_PRODUCT_LIST_URL?page=$currentPage';
  }
}

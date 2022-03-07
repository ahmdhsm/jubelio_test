import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../service/product/product.dart';

class HiveSourceService implements ProductSource {
  HiveSourceService(this.boxName);

  late Box<dynamic> box;

  final String boxName;

  Future<void> init() async {
    final Directory path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  }

  @override
  Future<Iterable<dynamic>> getData() async {
    await init();
    box = await Hive.openBox(boxName);
    return box.values;
  }

  @override
  Future<void> saveData(ProductModel model) async {
    await init();
    box = await Hive.openBox(boxName);
    final dynamic curData = box.get(model.productCode);
    if (curData != null) {
      final Map<String, dynamic> oldData = Map<String, dynamic>.from(curData as Map<dynamic, dynamic>);
      final List<String> imageURL = oldData['ImageURL'] as List<String>;
      if (imageURL.isNotEmpty) {
        model.imageURL = imageURL;
      }
    }
    box.put(model.productCode, model.modelToJson(model));
  }

  @override
  Future<Response<dynamic>?> getDioData(String url) {
    throw UnimplementedError();
  }
}

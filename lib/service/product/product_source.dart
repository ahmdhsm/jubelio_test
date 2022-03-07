import '../../util/util.dart';
import 'product_model.dart';

abstract class ProductSource {
  Future<Iterable<dynamic>> getData();

  Future<Response<dynamic>?> getDioData(String url);

  Future<void> saveData(ProductModel model);
}

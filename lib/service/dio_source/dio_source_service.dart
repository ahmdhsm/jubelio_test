import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../config/constants.dart';
import '../../service/product/product.dart';

class DioSourceService implements ProductSource {
  DioSourceService(this.header);

  final Map<String, dynamic> header;

  @override
  Future<Response<dynamic>?> getDioData(String url) async {
    final Dio dio = Dio();

    if (DIO_DEBUG == true) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    if (header != null) {
      for (final String item in header.keys) {
        dio.options.headers[item] = header[item];
      }
    }

    Response<dynamic> response;
    try {
      response = await dio.get(url);
    } catch (e) {
      return null;
    }
    return response;
  }

  @override
  Future<Iterable<dynamic>> getData() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveData(ProductModel model) {
    throw UnimplementedError();
  }
}

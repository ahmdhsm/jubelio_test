import '../../config/constants.dart';
import '../../util/util.dart';
import 'product.dart';

class ProductService<T extends ProductModel> {
  ProductService(this.productModel);

  final T productModel;

  Future<List<T>> getOfflineData<U extends ProductModel>(int maxData) async {
    final List<T> tempProductList = <T>[];

    if (productModel.offlineSource == null) {
      return <T>[];
    }

    final Iterable<dynamic> tempData =
        await productModel.offlineSource.getData();
    List<dynamic> tempDataList = tempData.toList();
    if (maxData != 0) {
      tempDataList = tempDataList.sublist(
            0,
            tempDataList.length > maxData ? maxData : tempDataList.length,
          );
    }
    for (final dynamic item in tempDataList) {
      final Map<String, dynamic> productItem =
          Map<String, dynamic>.from(item as Map<dynamic, dynamic>);
      tempProductList.add(productModel.jsonToModel(productItem) as T);
    }

    return tempProductList;
  }

  Future<List<T>> getOnlineData<U extends ProductModel>(int currentPage) async {
    List<T> tempProductList = <T>[];

    if (productModel.onlineSource == null) {
      return tempProductList;
    }

    final Response<dynamic>? tempData = await productModel.onlineSource
        .getDioData(productModel.urlListBuilder(currentPage));

    if (tempData == null) {
      if (currentPage == 1) {
        final List<T> offlineData = await getOfflineData(DATA_PER_PAGE);
        return offlineData;
      } else {
        return <T>[];
      }
    }

    tempProductList =
        await productModel.responseToListModel(tempData) as List<T>;

    for (final ProductModel item in tempProductList) {
      if (productModel.offlineSource != null) {
        await productModel.offlineSource.saveData(item);
      }
    }

    return tempProductList;
  }

  Future<T> getDetail<U extends ProductModel>(ProductModel model) async {
    final Response<dynamic>? tempData =
        await productModel.onlineSource.getDioData(model.urlDetailBuilder());

    if (tempData == null) {
      return model as T;
    }
    model = model.responseToModel(tempData);
    await productModel.offlineSource.saveData(model);

    return model as T;
  }
}

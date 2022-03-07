class CartProductModel {
  late int productCode;

  late String productName;

  late int productQty;

  late int productPrice;

  late int productStock;

  Map<String, dynamic> modelToJson(CartProductModel model) {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['ProductCode'] = model.productCode;
    json['ProductName'] = model.productName;
    json['ProductQty'] = model.productQty;
    // json['ProductSellPrice'] = model.productSellPrice;
    return json;
  }

  CartProductModel jsonToModel(Map<String, dynamic> json) {
    productCode = int.parse((json['ProductCode'] ?? 0).toString());
    productName = (json['ProductName'] ?? '') as String;
    productQty = int.parse((json['ProductQty'] ?? 1).toString());
    productPrice = 0;
    productStock = 0;
    return this;
  }

  void addQty() {
    if (productQty < productStock) {
      productQty += 1;
    }
  }

  void minQty() {
    if (productQty > 0) {
      productQty -= 1;
    }
  }
}

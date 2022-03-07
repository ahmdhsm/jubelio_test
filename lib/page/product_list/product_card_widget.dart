import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/constants.dart';
import '../../config/custom_formatter.dart';
import '../../config/route_generator.dart';
import '../../page/product_list/product_list_controller.dart';

// ignore: must_be_immutable
class ProductCardWidget extends ConsumerWidget {
  ProductCardWidget(this.productListController, this.currentProduct, {Key? key})
      : super(key: key);

  final ProductListController productListController;
  final ElevaniaProductModel currentProduct;
  late BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.context = context;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.detail,
            arguments: currentProduct,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: CARD_COLOR,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 50 / 100 * MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Image border
                  child: SizedBox.fromSize(child: cachedImage()),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      Text(
                        currentProduct.productName,
                        style: const TextStyle(fontSize: MEDIUM_FONT_SIZE),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          CustomFormatter.currencyFormat.format(currentProduct.productSellPrice),
                          style: const TextStyle(
                            fontSize: MEDIUM_FONT_SIZE,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${CustomFormatter.numberFormat.format(currentProduct.productSellQty)} Pcs',
                          style: const TextStyle(
                            fontSize: SMALL_FONT_SIZE,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(child: Container()),
                      if (productListController
                              .cartList[currentProduct.productCode]!
                              .productQty >
                          0)
                        buttonQty()
                      else
                        buttonAddToCart()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonQty() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            productListController.minQty(currentProduct);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: BUTTON_COLOR,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Icon(
                FontAwesomeIcons.minus,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            productListController
                .cartList[currentProduct.productCode]!.productQty
                .toString(),
          ),
        ),
        InkWell(
          onTap: () async {
            productListController.addQty(currentProduct);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: BUTTON_COLOR,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Icon(
                FontAwesomeIcons.plus,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonAddToCart() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () async {
            productListController.addQty(currentProduct);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: BUTTON_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              child: Text(
                'Add to cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cachedImage() {
    return CachedNetworkImage(
      width: 25 / 100 * MediaQuery.of(context).size.width,
      height: 25 / 100 * MediaQuery.of(context).size.width,
      imageUrl: currentProduct.imageURL.isNotEmpty
          ? currentProduct.imageURL.first
          : '',
      progressIndicatorBuilder: (BuildContext context, String url,
              DownloadProgress downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          const Icon(Icons.error),
    );
  }
}

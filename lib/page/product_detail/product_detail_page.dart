import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../config/custom_formatter.dart';
import '../../page/product_list/product_list_controller.dart';

class ProductDetailWidget extends ConsumerWidget {
  const ProductDetailWidget(this.obj, {Key? key}) : super(key: key);

  final Object? obj;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ElevaniaProductModel currentProduct = obj! as ElevaniaProductModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentProduct.productName),
        backgroundColor: HEADER_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              imageUrl: currentProduct.imageURL.isNotEmpty
                  ? currentProduct.imageURL.first
                  : '',
              progressIndicatorBuilder: (BuildContext context, String url,
                      DownloadProgress downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (BuildContext context, String url, dynamic error) =>
                  const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                currentProduct.productName,
                style: const TextStyle(
                  fontSize: BIG_FONT_SIZE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                CustomFormatter.currencyFormat.format(currentProduct.productSellPrice),
                style: const TextStyle(
                  fontSize: MEDIUM_FONT_SIZE,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '${CustomFormatter.numberFormat.format(currentProduct.productSellQty)} pcs',
                style: const TextStyle(
                  fontSize: SMALL_FONT_SIZE,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/constants.dart';
import '../../config/custom_formatter.dart';
import '../../config/route_generator.dart';
import '../../page/cart/cart_controller.dart';
import '../../service/cart/cart.dart';
import '../../service/elevania/elevania.dart';


// ignore: must_be_immutable
class CartCardWidget extends ConsumerWidget {
  CartCardWidget(this.cartController, this.currentProduct, {Key? key})
      : super(key: key);

  final CartController cartController;
  final CartProductModel currentProduct;
  late BuildContext context;

  late ElevaniaProductModel? fullProductInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.context = context;
    fullProductInfo = cartController.productList[currentProduct.productCode];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.detail,
            arguments: cartController.productList[currentProduct.productCode],
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentProduct.productName,
                  style: const TextStyle(fontSize: MEDIUM_FONT_SIZE),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            CustomFormatter.currencyFormat.format(fullProductInfo?.productSellPrice),
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
                            '${CustomFormatter.numberFormat.format(fullProductInfo?.productSellQty)} Pcs',
                            style: const TextStyle(
                              fontSize: SMALL_FONT_SIZE,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (currentProduct.productQty > 0)
                      buttonQty()
                    else
                      buttonAddToCart()
                  ],
                )
              ],
            ),
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
            cartController.minQty(currentProduct);
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
            currentProduct.productQty.toString(),
          ),
        ),
        InkWell(
          onTap: () async {
            cartController.addQty(currentProduct);
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
            cartController.addQty(currentProduct);
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
}

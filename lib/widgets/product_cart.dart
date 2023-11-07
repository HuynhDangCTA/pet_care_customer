import 'package:flutter/material.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

import '../core/colors.dart';
import '../model/product.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final Function(Product) onPick;
  final bool isHot;
  final Function(Product)? addToCart;

  const ProductCart(
      {super.key,
      required this.product,
      this.isAdmin = false,
      this.addToCart,
      this.isHot = false,
      required this.onPick});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPick(product);
      },
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                Container(
                    width: size.width,
                    height: 160,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        child: (product.image != null)
                            ? Image.network(
                                product.image!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/product_demo.jpg',
                                fit: BoxFit.contain,
                              ))),
                (isHot && product.amount! > 0)
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10)),
                              child: Image.asset('images/hot.png')),
                        ),
                      )
                    : Container(),
                (product.amount == null || product.amount! <= 0)
                    ? Container(
                        width: size.width,
                        height: 160,
                        color: Colors.white38,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(1000)),
                              child: AppText(
                                text: 'Hết hàng',
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            product.name!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          (product.discount! > 0)
                              ? Text(
                                NumberUtil.formatCurrency((product.price! *
                                    (100 - product.discount!) /
                                    100)),
                                style: const TextStyle(
                                  color: MyColors.primaryColor,
                                  fontSize: 18,
                                ),
                              )
                              : Container(),
                          Text(
                            '${NumberUtil.formatCurrency(product.price)}',
                            style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 17,
                              decoration: (product.discount! > 0)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          debugPrint('add cart');
                          addToCart!(product);
                        },
                        icon: Icon(Icons.add_shopping_cart)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

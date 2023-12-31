import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class ProductDetailPage extends GetView<ProductController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(controller.product!.image!, width: Get.width),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          text: controller.product!.name ?? '',
                          color: MyColors.primaryColor,
                          maxLines: 3,
                          size: 20,
                          isBold: true,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (controller.product!.discount! > 0)
                      ? AppText(
                          size: 18,
                          color: MyColors.primaryColor,
                          text: NumberUtil.formatCurrency(
                              (controller.product!.price! *
                                  (100 - controller.product!.discount!) /
                                  100)))
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  AppText(
                    text:
                        NumberUtil.formatCurrency(controller.product!.price) ??
                            '',
                    decoration: (controller.product!.discount! > 0)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    text: controller.product!.description ?? '',
                    maxLines: 10000,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(0, -2))
        ]),
        padding: const EdgeInsets.all(10),
        child: AppButton(
          onPressed: () {
            controller.addToCard(controller.product!);
          },
          text: 'Thêm vào giỏ hàng',
          isResponsive: true,
          isShadow: false,
        ),
      ),
    );
  }
}

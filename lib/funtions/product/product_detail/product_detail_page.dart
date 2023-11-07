import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class ProductDetailPage extends GetView<ProductController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: Column(
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
                    AppText(
                      text: controller.product!.name ?? '',
                      color: MyColors.primaryColor,
                      size: 20,
                      isBold: true,
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
                  text: NumberUtil.formatCurrency(controller.product!.price) ??
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
                AppText(text: controller.product!.description ?? ''),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

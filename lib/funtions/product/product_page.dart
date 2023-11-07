import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/empty_data.dart';
import 'package:pet_care_customer/widgets/product_cart.dart';
import 'package:pet_care_customer/widgets/search_field.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget productWidget = Obx(() => Column(
          children: [
            SearchField(
              text: 'Tìm kiếm sản phẩm',
              onChange: (value) {
                controller.searchProduct(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        children: List.generate(
                            controller.valueTypeFiller.value.length, (index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: AppText(
                                  size: 13,
                                  text: controller.valueTypeFiller[index],
                                ),
                              ),
                            ),
                          );
                        }),
                      )),
                ),
                IconButton(
                    onPressed: () {
                      controller.showFillter();
                    },
                    icon: const Icon(
                      Icons.filter_list_alt,
                      color: MyColors.primaryColor,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: (controller.products.isNotEmpty)
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.products.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.7),
                        itemBuilder: (context, index) {
                          return ProductCart(
                            isHot: (index < 5) ? true : false,
                            product: controller.products.value[index],
                            isAdmin: true,
                            onPick: (product) {
                              controller.goDetail(product);
                            },
                            addToCart: (product) async {
                              await controller.addToCard(product);
                            },
                          );
                        })
                    : const Center(child: EmptyDataWidget())),
          ],
        ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        child: productWidget,
      ),
    );
  }
}

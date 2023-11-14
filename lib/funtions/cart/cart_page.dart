import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/cart/cart_controller.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/cart_item.dart';
import 'package:pet_care_customer/widgets/empty_data.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Obx(() => (controller.products.isNotEmpty)
          ? ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(
                  product: controller.products[index],
                  onChangeSelected: () {
                    controller.changeSelected(index);
                  },
                  onIncrease: () async {
                    await controller.increase(index);
                  },
                  onDecrease: () async {
                    await controller.decrease(index);
                  },
                  onDelete: () async {
                    await controller.deleteProduct(index);
                  },
                );
              },
              itemCount: controller.products.value.length)
          : const Center(
              child: EmptyDataWidget(),
            )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(0, -2))
        ]),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Tổng tiền: ',
                  isBold: true,
                )),
                Obx(() => Expanded(
                        child: AppText(
                      text: NumberUtil.formatCurrency(
                          controller.totalMoney.value),
                      textAlign: TextAlign.end,
                    )))
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Giảm giá:',
                  isBold: true,
                )),
                Obx(() => Expanded(
                        child: AppText(
                      text: NumberUtil.formatCurrency(
                          controller.discountMoney.value),
                      textAlign: TextAlign.end,
                    )))
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Thanh toán:',
                  isBold: true,
                )),
                Obx(() => Expanded(
                        child: AppText(
                      text:
                          NumberUtil.formatCurrency(controller.payMoney.value),
                      textAlign: TextAlign.end,
                    )))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            AppButton(
              onPressed: () {
                controller.order();
              },
              text: 'Đặt hàng',
              isShadow: false,
              isResponsive: true,
            )
          ],
        ),
      ),
    );
  }
}

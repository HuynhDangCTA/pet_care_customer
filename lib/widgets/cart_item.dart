import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/number_selected.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final Function() onChangeSelected;
  final Function() onIncrease;
  final Function() onDecrease;
  final Function() onDelete;

  const CartItem(
      {super.key,
      required this.product,
      required this.onChangeSelected,
      required this.onIncrease,
      required this.onDecrease,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: product.selected,
                      onChanged: (value) {
                        onChangeSelected();
                      },
                    ),
                    Container(
                      height: 116,
                      width: 1,
                      color: MyColors.cardColor2,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(product.image!))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(
                                  text: product.name ?? '',
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                AppText(
                                    decoration: (product.discount! > 0)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    text: NumberUtil.formatCurrency(
                                        product.price)),
                                const SizedBox(
                                  height: 5,
                                ),
                                (product.discount! > 0)
                                    ? AppText(
                                        text: NumberUtil.formatCurrency(
                                            (product.price! *
                                                (100 - product.discount!) /
                                                100)))
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: NumberSelected(
                increase: () {
                  onIncrease();
                },
                decrease: () {
                  onDecrease();
                },
                textController:
                    TextEditingController(text: product.sold.toString()),
              )),
          (product.amount < product.sold)
              ? const Positioned(
                  bottom: 10,
                  right: 130,
                  child: AppText(
                    text: 'Không đủ hàng',
                    color: Colors.red,
                    size: 10,
                  ))
              : Container()
        ],
      ),
    );
  }
}

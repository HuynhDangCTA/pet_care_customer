import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/order/order_status.dart';
import 'package:pet_care_customer/model/order_model.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/model/voucher.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/util/dialog_util.dart';

class MyOrderController extends GetxController {
  RxList<OrderModel> orders = <OrderModel>[].obs;
  UserResponse? user = HomeController.instants.userCurrent;
  late StreamSubscription orderListener;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listenOrder();
  }

  void listenOrder() {
    orderListener = FirebaseHelper.listenOrder(
      user!.id!,
      onAdded: (order) async {
        await FirebaseHelper.getProductFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            List<Product> result = [];
            for (var doc in value.docs) {
              Product product =
                  Product.fromDocument(doc.data() as Map<String, dynamic>);
              product.id = doc.id;
              result.add(product);
            }
            order.product = result;
          }
        });
        await FirebaseHelper.getVoucherFromOrder(order.id!).then((value) {
          if (value.docs.isNotEmpty) {
            Voucher voucher = Voucher.fromMap(
                value.docs.first.data() as Map<String, dynamic>);
            voucher.id = value.docs.first.id;
            order.voucher = voucher;
          }
        });
        order.orderBy = user;
        orders.add(order);
      },
      onModified: (order) {
        if (orders.contains(order)) {
          orders[orders.indexOf(order)].status = order.status;
          orders.refresh();
        }
      },
      onRemoved: (order) {
        orders.remove(order);
      },
    );
  }

  Future cancelOrder(OrderModel order) async {
    await FirebaseHelper.updateStatusOrder(order.id!, OrderStatusConst.huyDon)
        .then((value) async {
      for (var product in order.product!) {
        await FirebaseHelper.getProductFromID(product.id!).then((value) async {
          int amount = value.get(Constants.amount);
          amount += product.sold;
          await FirebaseHelper.updateAmountProduct(product.id!, amount);
        });
      }
      DialogUtil.showSnackBar('Hủy đơn thành công');
    });
  }

  @override
  void onClose() {
    super.onClose();
    orderListener.cancel();
  }
}

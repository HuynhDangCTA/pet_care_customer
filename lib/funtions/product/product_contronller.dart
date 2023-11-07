import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/model/discount.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/model/service.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/util/dialog_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class ProductController extends GetxController {
  RxList<Product> products = RxList();
  RxList<ServiceModel> services = RxList();
  List<Product> productsGet = [];
  RxList<bool> valueFillter = <bool>[].obs;
  RxList<String> valueTypeFiller = <String>[].obs;
  RxList<String> typeProducts = <String>[].obs;
  Product? product;

  @override
  void onReady() async {
    super.onReady();
    await getAllProducts();
  }

  Future getAllProducts() async {
    DialogUtil.showLoading();
    products.clear();

    await FirebaseHelper.getAllProducts().then((value) async {
      if (value.docs.isNotEmpty) {
        List<Product> result = [];
        DialogUtil.hideLoading();
        for (var doc in value.docs) {
          Product product =
              Product.fromDocument(doc.data() as Map<String, dynamic>);
          product.id = doc.id;
          debugPrint('Product ${product.name}');
          result.add(product);
        }
        productsGet = result;
        products.addAll(productsGet);
      }
    });

    Discount? discount;
    await FirebaseHelper.getDiscountInDate(DateTime.now()).then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var item in value.docs) {
            discount = Discount.fromMap(item.data() as Map<String, dynamic>);
            if (DateTime.now().isBefore(discount!.fromDate!)) {
              discount = null;
            }

            if (discount != null) {
              if (discount!.isAllProduct!) {
                for (var product in productsGet) {
                  product.discount = discount!.discount!;
                }
                products.clear();
                products.addAll(productsGet);
              } else {
                for (var product in productsGet) {
                  if (discount!.productId!.contains(product.id)) {
                    product.discount = discount!.discount!;
                  }
                }
                products.clear();
                products.addAll(productsGet);
              }
            }
          }
        }
      },
    );
  }

  void searchProduct(String? value) {
    products.clear();
    if (value == null || value.isEmpty) {
      products.addAll(productsGet);
    } else {
      for (var item in productsGet) {
        if (item.name!.toLowerCase().contains(value.toLowerCase())) {
          products.value.add(item);
        }
      }
    }
  }

  Future getTypeProducts() async {
    await FirebaseHelper.getTypeProducts().then((value) {
      for (var item in value.docs) {
        typeProducts.add(item[Constants.type]);
      }
    });
  }

  Future addToCard(Product product) async {
    UserResponse? user = HomeController.instants.userCurrent;
    // debugPrint('user cart: $user');
    if (user == null) {
      Get.toNamed(RoutesConst.login);
    } else {}
  }

  void showFillter() async {
    if (typeProducts.isEmpty) {
      await getTypeProducts();
    }

    if (valueFillter.isEmpty) {
      valueFillter.addAll(List.generate(typeProducts.length, (index) => false));
    }

    RxList<bool> valueTemp =
        List.generate(typeProducts.length, (index) => valueFillter[index]).obs;

    Get.defaultDialog(
        title: 'Bộ lọc',
        backgroundColor: Colors.white,
        content: Container(
            width: Get.width,
            height: Get.width,
            // color: Colors.white,
            child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        valueTemp[index] = !valueTemp[index];
                      },
                      title: AppText(
                        text: typeProducts.value[index],
                      ),
                      leading: Checkbox(
                        activeColor: MyColors.primaryColor,
                        value: valueTemp.value[index],
                        onChanged: (value) {
                          valueTemp[index] = !valueTemp[index];
                        },
                      ),
                    );
                  },
                  itemCount: valueTemp.value.length,
                ))),
        actions: [
          AppButton(
            onPressed: () {
              valueTypeFiller.clear();
              valueFillter.value = valueTemp.value;
              for (int i = 0; i < valueFillter.length; i++) {
                if (valueFillter[i]) {
                  if (!valueTypeFiller.contains(typeProducts[i])) {
                    valueTypeFiller.add(typeProducts[i]);
                  }
                } else {
                  if (valueTypeFiller.contains(typeProducts[i])) {
                    valueTypeFiller.remove(typeProducts[i]);
                  }
                }
              }

              products.clear();
              if (valueTypeFiller.isEmpty) {
                products.addAll(productsGet);
              }
              for (var item in valueTypeFiller) {
                for (var product in productsGet) {
                  if (product.type == item) {
                    products.add(product);
                  }
                }
              }
              Get.back();
            },
            text: 'Lưu',
          ),
          AppButton(
              onPressed: () {
                valueTemp.clear();
                Get.back();
              },
              text: 'Đóng',
              backgroundColor: MyColors.textColor),
        ]);
  }

  void goDetail(Product product) {
    this.product = product;
    Get.toNamed(RoutesConst.productDetail);
  }
}

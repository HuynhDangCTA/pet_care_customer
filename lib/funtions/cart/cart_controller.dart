import 'package:get/get.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/model/discount.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/util/dialog_util.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  RxList<Product> products = <Product>[].obs;
  UserResponse? user = HomeController.instants.userCurrent;
  RxInt totalMoney = 0.obs;
  RxInt discountMoney = 0.obs;
  RxInt payMoney = 0.obs;

  @override
  void onReady() async {
    print('onReady');
    await getProductsCart();
    super.onReady();
  }


  Future getProductsCart() async {
    if (user == null) {
      return;
    }
    DialogUtil.showLoading();
    await FirebaseHelper.getAllProductFromCart(user!.id!).then((value) async {
      if (value.docs.isNotEmpty) {
        List<Product> result = [];
        for (var doc in value.docs) {
          int amount = doc.get(Constants.amount);

          await FirebaseHelper.getProductFromID(doc.id).then((value) async {
            Product product =
                Product.fromDocument(value.data() as Map<String, dynamic>);
            product.id = value.id;
            product.sold = amount;
            result.add(product);
          });
        }
        products.addAll(result);
      }
    });

    await FirebaseHelper.getDiscountInDate(DateTime.now()).then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var item in value.docs) {
            Discount? discount;
            discount = Discount.fromMap(item.data() as Map<String, dynamic>);
            if (DateTime.now().isBefore(discount.fromDate!)) {
              discount = null;
            }
            if (discount != null) {
              if (discount.isAllProduct!) {
                for (var product in products) {
                  product.discount = discount.discount!;
                }
              } else {
                for (var product in products) {
                  if (discount.productId!.contains(product.id)) {
                    product.discount = discount.discount!;
                  }
                }
              }
            }
          }
          products.refresh();
        }
      },
    );
    DialogUtil.hideLoading();
  }

  void changeSelected(index) {
    products[index].selected = !products[index].selected;
    products.refresh();
    calculationMoney();
  }

  void calculationMoney() {
    int money = 0;
    int discount = 0;
    for (var product in products) {
      if (product.selected) {
        money += product.sold * product.price!;
        if (product.discount! > 0) {
          discount +=
              ((product.price! * product.discount!) / 100 * product.sold)
                  .round();
        }
      }
    }
    discountMoney.value = discount;
    totalMoney.value = money;
    payMoney.value = totalMoney.value - discountMoney.value;
  }

  Future increase(index) async {
    if (products[index].sold < products[index].amount) {
      products[index].sold += 1;
      await FirebaseHelper.updateCart(
          products[index], user!.id!, products[index].sold);
    }
    products.refresh();
    calculationMoney();
  }

  Future decrease(index) async {
    if (products[index].sold > 1) {
      products[index].sold -= 1;
      await FirebaseHelper.updateCart(
          products[index], user!.id!, products[index].sold);
    }
    products.refresh();
    calculationMoney();
  }

  Future deleteProduct(index) async {
    DialogUtil.showLoading();
    await FirebaseHelper.deleteProductFromCart(user!.id!, products[index].id!)
        .then((value) {
      DialogUtil.hideLoading();
    });
    products.removeAt(index);
    products.refresh();
  }

  void order() {
    if (totalMoney.value <= 0) {
      DialogUtil.showSnackBar('Chọn sản phẩm');
    } else {
      List<Product> selected = [];
      for (var product in products) {
        if (product.selected) {
          selected.add(product);
          print('discount: ${product.discount}');
          if (product.amount < product.sold) {
            DialogUtil.showSnackBar('Không đủ sản phẩm trong kho');
            return;
          }
        }
      }
      Get.toNamed(RoutesConst.order, arguments: selected);
    }
  }
}

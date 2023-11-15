import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/register/register_controller.dart';
import 'package:pet_care_customer/model/state.dart';
import 'package:pet_care_customer/model/user_request.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/services/fcm_service.dart';
import 'package:pet_care_customer/util/encode_util.dart';
import 'package:pet_care_customer/util/shared_pref.dart';

class LoginController extends GetxController {
  RxBool passwordInVisible = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString error = ''.obs;
  Rx<AppState> state = Rx<AppState>(StateSuccess());

  @override
  void onInit() async {
    super.onInit();
  }

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  Future<void> login() async {
    String name = userNameController.text;
    String password = passwordController.text;
    String passwordSHA = EncodeUtil.generateSHA256(password);
    UserRequest user = UserRequest(name: name, password: passwordSHA);
    state.value = StateLoading();
    await FirebaseHelper.login(user).then((value) async {
      if (value != null && value.docs.isNotEmpty) {
        state.value = StateSuccess();
        UserResponse userResponse =
            UserResponse.fromMap(value.docs[0].data() as Map<String, dynamic>);
        userResponse.id = value.docs[0].id;
        debugPrint('userlogin: ${userResponse.name}');
        String? token = await FCMService.getToken(userResponse.id!);
        userResponse.token = token;
        await SharedPref.setUser(userResponse);
        Get.lazyPut(() => HomeController());
        HomeController.instants.userCurrent = userResponse;
        HomeController.instants.listenCart();
        // Get.offAndToNamed(RoutesConst.home, arguments: user);
        Get.offAllNamed(RoutesConst.home, arguments: user);
      } else {
        state.value = StateError('Tài khoản hoặc mật khẩu không đúng');
      }
    });
  }

  void goToRegister() {
    Get.lazyPut(() => RegisterController());
    Get.toNamed(RoutesConst.register);
  }

}

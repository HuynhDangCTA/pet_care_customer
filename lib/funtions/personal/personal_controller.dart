
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/model/user_response.dart';

class PersonalController extends GetxController {
  UserResponse? user = HomeController.instants.userCurrent;
}
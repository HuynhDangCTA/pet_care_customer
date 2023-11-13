import 'package:get/get.dart';
import 'package:pet_care_customer/model/room.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';

class RoomController extends GetxController {
  RxInt currentStep = 0.obs;

  RxList<Room> roomsCat = <Room>[].obs;
  RxList<Room> roomsDog = <Room>[].obs;

  @override
  void onInit() {
    listenRoomCat();
    listenRoomDog();
    super.onInit();
  }

  void listenRoomCat() {
    FirebaseHelper.listenRoomCat(
      onAdded: (room) {
        roomsCat.add(room);
      },
      onModified: (room) {
        if (roomsCat.contains(room)) {
          roomsCat[roomsCat.indexOf(room)] = room;
        }
      },
      onRemoved: (room) {
        roomsCat.remove(room);
      },
    );
  }

  void listenRoomDog() {
    FirebaseHelper.listenRoomDog(
      onAdded: (room) {
        roomsDog.add(room);
      },
      onModified: (room) {
        if (roomsDog.contains(room)) {
          roomsDog[roomsDog.indexOf(room)] = room;
        }
      },
      onRemoved: (room) {
        roomsDog.remove(room);
      },
    );
  }
}

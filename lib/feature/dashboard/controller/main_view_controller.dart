import 'package:get/get.dart';

class MainViewController extends GetxController {
  static MainViewController get to => Get.find<MainViewController>();

  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

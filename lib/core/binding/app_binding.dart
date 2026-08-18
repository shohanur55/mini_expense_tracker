import 'package:get/get.dart';


import '../../features/navbar/controller/main_view_controller.dart';
import '../../features/notification/controller/notification_controller.dart';
import '../../features/profile/controller/edit_profile_controller.dart';
import '../../features/profile/controller/faq_controller.dart';
import '../../features/profile/controller/my_wallet_controller.dart';
import '../../features/profile/controller/notification_setting_controller.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../features/set_up_profile/controller/enter_location_controller.dart';
import '../../features/set_up_profile/controller/id_passport_verify_controller.dart';
import '../../features/set_up_profile/controller/location_controller.dart';
import '../../features/set_up_profile/controller/set_up_profile_form_controller.dart';
import '../../features/sign_in_and_sign_up/controller/otp_controller.dart';
import '../../features/sign_in_and_sign_up/controller/sign_in_controller.dart';
import '../../features/splash/controller/slider_controller.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../global_widget/controller/custom_date_time_controller.dart';
import '../global_widget/controller/custom_drop_down_controller.dart';
import '../global_widget/image_picker_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdPassportVerifyController>(() => IdPassportVerifyController(),fenix: true);
    Get.lazyPut<SliderController>(() => SliderController(),fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(),fenix: true);
    Get.lazyPut<OTPController>(() => OTPController(),fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(),fenix: true);
    Get.lazyPut<LocationController>(() => LocationController(),fenix: true);
    Get.lazyPut<EnterLocationController>(() => EnterLocationController(),fenix: true);
    Get.lazyPut<CustomDropDownController>(() => CustomDropDownController(),fenix: true);
    Get.lazyPut<CustomDateTimeController>(() => CustomDateTimeController(),fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(),fenix: true);
    Get.lazyPut<MainViewController>(() => MainViewController(),fenix: true);
    Get.lazyPut<ImagePickerController>(() => ImagePickerController(),fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(),fenix: true);
    Get.lazyPut<EditProfileController>(() => EditProfileController(),fenix: true);
    Get.lazyPut<MyWalletController>(() => MyWalletController(),fenix: true);
    Get.lazyPut<NotificationSettingController>(() => NotificationSettingController(),fenix: true);
    Get.lazyPut<FAQController>(() => FAQController(),fenix: true);
    Get.lazyPut<SetUpProfileFormController>(() => SetUpProfileFormController(),fenix: true);
  }
}

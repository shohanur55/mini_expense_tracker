import 'package:get/get.dart';
import '../../features/navbar/screens/main_view.dart';
import '../../features/notification/screens/notification_screen.dart';
import '../../features/profile/screens/add_new_card.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/my_wallet_screen.dart';
import '../../features/profile/screens/notification_setting_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/support_screen.dart';
import '../../features/set_up_profile/screens/allow_location_screen.dart';
import '../../features/set_up_profile/screens/enter_location_screen.dart';
import '../../features/set_up_profile/screens/id_passport_verify_screen.dart';
import '../../features/set_up_profile/screens/set_up_profile_form.dart';
import '../../features/sign_in_and_sign_up/screens/otp_screen.dart';
import '../../features/sign_in_and_sign_up/screens/sign_in_screen.dart';
import '../../features/splash/screens/slider_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/splash/screens/splash_two_screen.dart';

class AppRoute {
  static const String splash = '/Spalsh';
  static const String slider = '/SliderScreen';
  static const String splashTwo = '/SpalshTwo';
  static const String signin = '/SigninScreen';
  static const String otp = '/OtpScreen';
  static const String locationAccess = '/AllowLocationAccess';
  static const String enterLocation = '/EnterLocation';
  static const String uploadDocuments = '/UploadDocuments';
  static const String setupProfile = '/SetupProfile';
  static const String notifications = '/Notifications';
  static const String myOrders = '/MyOrders';
  static const String cancelOrders = '/CancelOrders';
  static const String mainView = '/MainView';
  static const String editProfile = '/EditProfile';
  static const String myWallet = '/MyWalletScreen';
  static const String addNewCard = '/AddNewCard';
  static const String notificationSetting = '/NotificationSetting';
  static const String support = '/SupportScreen';
  static const String privacy = '/PrivacyPolicy';

  static final route = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: slider,
      page: () => SliderScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: splashTwo,
      page: () => SplashTwoScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signin,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: otp,
      page: () => OtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: locationAccess,
      page: () => AllowLocationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: enterLocation,
      page: () => EnterLocationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: uploadDocuments,
      page: () => IdPassportVerifyScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: setupProfile,
      page: () => SetUpProfileForm(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: notifications,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: mainView,
      page: () => MainView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: myWallet,
      page: () => MyWalletScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addNewCard,
      page: () => AddNewCard(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: notificationSetting,
      page: () => NotificationSettingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: support,
      page: () => SupportScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacy,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}

class AppUrls {
  static const String _baseUrl = 'https://nanwa.fr/api/v1';
  //static const String _baseUrl = 'https://nanwa.fr/api/v1';
  static const String registerUrl = '$_baseUrl/users/create';

  static const String loginUrl = '$_baseUrl/auth/login';
  static const String send_otp = '$_baseUrl/auth/send-otp';
  static const String verify_otp = '$_baseUrl/auth/verify-otp';
  static const String update_location = '$_baseUrl/auth/update/location';
  static const String updateUser = '$_baseUrl/users/';
  static const String user = '$_baseUrl/auth/profile';
  static const String updatePassengerDoccument =
      '$_baseUrl/auth/update/driver-document';
  static const String updateProfilePicture =
      '$_baseUrl/auth/update/profile-image';
  static const String orderType = '$_baseUrl/booking/passengers';
  static const String updateOrder = '$_baseUrl/booking/status-update';

  static const String orderList = '$_baseUrl/booking/order-list';
  static const String singleOrder = '$_baseUrl/booking';
  static const String conversationList = '$_baseUrl/chat/convarstion-list';
  static const String getConversation = '$_baseUrl/chat/get-single-message';
  static const String paymentHistory =
      '$_baseUrl/payment/driver-payment-history';
  static const String withdraw = '$_baseUrl/payment/withdraw';
  static const String notifications = '$_baseUrl/notification';
  static const String verifyTransaction =
      '$_baseUrl/payment/driver-top-up-transaction';

  //TODO: Payment url will be change
  static const plan = "$_baseUrl/plans";
  static const payment = "$_baseUrl/payments";

  static const money_received = "$_baseUrl/payment/money-receive";
}

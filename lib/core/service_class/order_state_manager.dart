import 'dart:convert';
import 'package:driver_part/core/helper/shared_prefarenses_helper.dart';

enum OrderState { none, accepted, pickupStarted, dropoffDone }

class OrderStateManager {
  static final OrderStateManager _instance = OrderStateManager._internal();

  factory OrderStateManager() => _instance;

  OrderStateManager._internal();

  final SharedPreferencesHelper _prefs = SharedPreferencesHelper();

  static const String _orderStateKey = 'active_order_state';
  static const String _orderIdKey = 'active_order_id';
  static const String _orderDataKey = 'active_order_data';
  static const String _pickupLatKey = 'pickup_lat';
  static const String _pickupLngKey = 'pickup_lng';
  static const String _dropoffLatKey = 'dropoff_lat';
  static const String _dropoffLngKey = 'dropoff_lng';
  static const String _totalPriceKey = 'total_price';
  static const String _pickupStartTimeKey = 'pickup_start_time';
  static const String _metersKey = 'meters_traveled';

  // Save order state when accepted
  Future<void> saveAcceptedOrder(
    String orderId,
    Map<String, dynamic> orderData,
    double pickupLat,
    double pickupLng,
    double dropoffLat,
    double dropoffLng,
    String totalPrice,
  ) async {
    await _prefs.setString(_orderStateKey, OrderState.accepted.toString());
    await _prefs.setString(_orderIdKey, orderId);
    await _prefs.setString(_orderDataKey, jsonEncode(orderData));
    await _prefs.setDouble(_pickupLatKey, pickupLat);
    await _prefs.setDouble(_pickupLngKey, pickupLng);
    await _prefs.setDouble(_dropoffLatKey, dropoffLat);
    await _prefs.setDouble(_dropoffLngKey, dropoffLng);
    await _prefs.setString(_totalPriceKey, totalPrice);
  }

  // Save pickup started state with timestamp and meter data
  Future<void> savePickupStarted(
    String orderId,
    DateTime pickupStartTime,
    int meters,
  ) async {
    await _prefs.setString(_orderStateKey, OrderState.pickupStarted.toString());
    await _prefs.setString(_orderIdKey, orderId);
    await _prefs.setString(
      _pickupStartTimeKey,
      pickupStartTime.toIso8601String(),
    );
    await _prefs.setInt(_metersKey, meters);
  }

  // Clear order state
  Future<void> clearOrderState() async {
    await _prefs.remove(_orderStateKey);
    await _prefs.remove(_orderIdKey);
    await _prefs.remove(_orderDataKey);
    await _prefs.remove(_pickupLatKey);
    await _prefs.remove(_pickupLngKey);
    await _prefs.remove(_dropoffLatKey);
    await _prefs.remove(_dropoffLngKey);
    await _prefs.remove(_totalPriceKey);
    await _prefs.remove(_pickupStartTimeKey);
    await _prefs.remove(_metersKey);
  }

  // Get current order state
  OrderState getOrderState() {
    String? stateString = _prefs.getString(_orderStateKey);
    if (stateString == null) {
      return OrderState.none;
    }
    if (stateString == 'OrderState.accepted') {
      return OrderState.accepted;
    } else if (stateString == 'OrderState.pickupStarted') {
      return OrderState.pickupStarted;
    }
    return OrderState.none;
  }

  // Get active order ID
  String? getActiveOrderId() {
    return _prefs.getString(_orderIdKey);
  }

  // Get order data
  Map<String, dynamic>? getOrderData() {
    String? dataString = _prefs.getString(_orderDataKey);
    if (dataString == null) {
      return null;
    }
    try {
      return jsonDecode(dataString);
    } catch (e) {
      return null;
    }
  }

  // Get pickup location
  Map<String, double>? getPickupLocation() {
    double? lat = _prefs.getDouble(_pickupLatKey);
    double? lng = _prefs.getDouble(_pickupLngKey);
    if (lat == null || lng == null) {
      return null;
    }
    return {'lat': lat, 'lng': lng};
  }

  // Get dropoff location
  Map<String, double>? getDropoffLocation() {
    double? lat = _prefs.getDouble(_dropoffLatKey);
    double? lng = _prefs.getDouble(_dropoffLngKey);
    if (lat == null || lng == null) {
      return null;
    }
    return {'lat': lat, 'lng': lng};
  }

  // Get total price
  String? getTotalPrice() {
    return _prefs.getString(_totalPriceKey);
  }

  // Get pickup start time
  DateTime? getPickupStartTime() {
    String? timeString = _prefs.getString(_pickupStartTimeKey);
    if (timeString == null) {
      return null;
    }
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // Get meters traveled
  int getMeters() {
    return _prefs.getInt(_metersKey) ?? 0;
  }

  // Update meters traveled (useful to keep state synced during pickup)
  Future<void> updateMeters(int meters) async {
    await _prefs.setInt(_metersKey, meters);
  }

  // Check if there's an active order
  bool hasActiveOrder() {
    return getOrderState() != OrderState.none;
  }
}

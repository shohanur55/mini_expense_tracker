import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../helper/shared_prefarenses_helper.dart';

class SocketService extends GetxService {
  WebSocketChannel? _channel;
  final RxBool isConnected = false.obs;
  final RxnString pendingWalletFailure = RxnString();
  final String _url = "wss://nanwa.fr";

  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  final StreamController<String> _walletFailureController =
      StreamController<String>.broadcast();
  Stream<String> get walletFailureStream => _walletFailureController.stream;

  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  Timer? _reconnectTimer;

  Future<SocketService> init() async {
    await _sharedPreferencesHelper.init();
    connect();
    return this;
  }

  void connect() {
    if (isConnected.value) {
      debugPrint("SocketService: Already connected.");
      return;
    }

    String authToken = _sharedPreferencesHelper.getString("userToken") ?? "";
    debugPrint("SocketService: Auth token length: ${authToken.length}");

    if (authToken.isEmpty) {
      debugPrint("SocketService: No auth token found. Skipping connection.");
      return;
    }

    bool isInactive = _sharedPreferencesHelper.getBool("isInactive") ?? false;
    debugPrint("SocketService: isInactive flag: $isInactive");

    if (isInactive) {
      debugPrint("SocketService: User is inactive. Skipping connection.");
      return;
    }

    try {
      debugPrint(
        "SocketService: Connecting to $_url with token: ${authToken.substring(0, min(10, authToken.length))}...",
      );
      _channel = IOWebSocketChannel.connect(
        Uri.parse(_url),
        headers: {"x-token": authToken},
      );

      debugPrint(
        "SocketService: WebSocket channel created, waiting for connection...",
      );

      _channel!.stream.listen(
        (message) {
          // Set connected status only after first message received
          if (!isConnected.value) {
            isConnected.value = true;
            debugPrint("SocketService: Connected and received first message");
          }

          try {
            if (message is String) {
              final decoded = jsonDecode(message);
              if (decoded is Map &&
                  decoded['type'] == 'driver_wallet_failure') {
                pendingWalletFailure.value = message;
                _walletFailureController.add(message);
              }
            }
          } catch (_) {
            // Ignore parse errors; still forward the raw message.
          }

          debugPrint("SocketService Received: $message");
          _messageController.add(message);
        },
        onError: (error) {
          debugPrint('SocketService Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('SocketService Closed');
          _handleDisconnect();
        },
      );

      // Try to establish connection by sending a ping or initial message
      // Set connected after a small delay to allow connection to establish
      Future.delayed(Duration(milliseconds: 200), () {
        if (_channel != null) {
          isConnected.value = true;
          debugPrint("SocketService: Connection established and ready");
        }
      });

      debugPrint("SocketService: Stream listener attached");
    } catch (e) {
      debugPrint('SocketService Connection Failed: $e');
      _handleDisconnect();
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    isConnected.value = false;
    debugPrint("SocketService: Disconnected manually.");
  }

  /// Returns any wallet failure message that arrived before listeners attached.
  String? consumePendingWalletFailure() {
    final value = pendingWalletFailure.value;
    pendingWalletFailure.value = null;
    return value;
  }

  void _handleDisconnect() {
    isConnected.value = false;
    _channel = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect();
    });
  }

  void send(dynamic message) {
    if (_channel != null && isConnected.value) {
      final stringMessage = message is String ? message : jsonEncode(message);
      debugPrint("SocketService Sending: $stringMessage");
      _channel!.sink.add(stringMessage);
    } else {
      debugPrint("SocketService: Cannot send, not connected.");
    }
  }

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _messageController.close();
    _walletFailureController.close();
    super.onClose();
  }
}

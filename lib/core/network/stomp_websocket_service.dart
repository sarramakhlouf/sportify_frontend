import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef NotificationCallback = void Function(dynamic notif);

class StompWebSocketService {
  StompClient? _stompClient;

  void connect({
    required String userId,
    required String token,
    required NotificationCallback onNotification,
  }) {
    if (_stompClient != null) return;

    _stompClient = StompClient(
      config: StompConfig(
        url: 'wss://cinderella-unfasciated-imogene.ngrok-free.dev/ws', // WebSocket pur
        onConnect: (frame) {
          print('✅ STOMP connecté');
          _stompClient!.subscribe(
            destination: '/user/$userId/queue/notifications',
            callback: (StompFrame frame) {
              onNotification(frame.body);
            },
          );
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        heartbeatIncoming: Duration.zero,
        heartbeatOutgoing: const Duration(seconds: 20),
        reconnectDelay: const Duration(seconds: 5),
        onWebSocketError: (error) {
          print('❌ WebSocket error: $error');
        },
      ),
    );
    

    _stompClient!.activate();
  }

  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
  }
}

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Notifications {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "end_of_deck",
          channelName: "End of Deck",
          channelDescription: "Notification for reaching the end of a deck",
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> displayEndOfDeckNotification({
    required final String notificationTitle,
    required final String notificationBody,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "end_of_deck",
        title: notificationTitle,
        body: notificationBody,
        notificationLayout: NotificationLayout.Default,
        payload: {'navigate': 'decks_screen'},
      ),
    );
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction action,
  ) async {
    if (action.payload?['navigate'] == 'decks_screen') {
      navigatorKey.currentState?.pushNamed('/decks_screen');
    }
  }
}

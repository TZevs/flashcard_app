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
          playSound: true,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: "daily_reminder",
          channelName: "Daily Reminder",
          channelDescription:
              "Notification for a daily reminder to review decks.",
          playSound: true,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: "user_registered",
          channelName: "User Registered",
          channelDescription: "Notification to take user to login page.",
          playSound: true,
          importance: NotificationImportance.High,
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> displayEndOfDeckNotification({
    required String notificationTitle,
    required String notificationBody,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "end_of_deck",
        title: notificationTitle,
        body: notificationBody,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> displayReminderNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: "daily_reminder",
        title: "Daily Reminder!",
        body: "Don't forget to review your decks today",
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 17,
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
        preciseAlarm: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }

  static Future<void> displayUserRegisteredNotification({
    required String notificationTitle,
    required String notificationBody,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: "user_registered",
        title: notificationTitle,
        body: notificationBody,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction action,
  ) async {
    final String? channelKey = action.channelKey;

    switch (channelKey) {
      case "end_of_deck":
        navigatorKey.currentState?.pushNamed('/decks_screen');
      case "user_registered":
        navigatorKey.currentState?.pushNamed('/login_screen');
      default:
        break;
    }
  }
}

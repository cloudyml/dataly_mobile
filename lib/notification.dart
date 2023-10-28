import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotiFicationServ{
  Future init() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF4C76EA),
          ledColor: Colors.white,
        ),

      ],
    );
  }
  Future<void> showBasicNotification(QueryDocumentSnapshot<Map<String, dynamic>> event) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 12,
          channelKey: 'basic_channel',
          title: event.get('title'),
          notificationLayout: NotificationLayout.BigText,
          largeIcon: event.get('icon'),
          body: event.get('description'),
        ));
  }
}

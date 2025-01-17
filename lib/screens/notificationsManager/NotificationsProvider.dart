import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners(); // Notifica os ouvintes para atualizar o estado
  }
}
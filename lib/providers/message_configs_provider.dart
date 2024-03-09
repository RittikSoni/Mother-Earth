import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_collect/constants/kdimens.dart';

import 'package:eco_collect/models/user_data_model.dart';
import 'package:flutter/material.dart';

class MessageConfigProvider extends ChangeNotifier {
  int currentMessageTimer = 0;
  bool canSendMessage = true;
  Timer? _timer;

  void startMessageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentMessageTimer > 0) {
        currentMessageTimer--;
        notifyListeners();
      } else {
        canSendMessage = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void sendMessage(
      {required String senderText, required UserDataModel currentUser}) async {
    if (canSendMessage) {
      await FirebaseFirestore.instance.collection('messages').add({
        "country": currentUser.country,
        "trophies": currentUser.trophies,
        "xp": currentUser.xp,
        'senderName': currentUser.fullName,
        'senderEmail': currentUser.email,
        'senderUsername': currentUser.username,
        'senderText': senderText,
        'timestamp': FieldValue.serverTimestamp(),
        'localTimestamp': DateTime.now().toIso8601String(),
      });

      // Start the timer
      currentMessageTimer = KDimens.sendNewMessageTimerInSeconds; // Set timer
      canSendMessage = false;
      startMessageTimer();
    }
  }

  void reset() {
    currentMessageTimer = 0;
    canSendMessage = true;
    _timer?.cancel();
  }
}

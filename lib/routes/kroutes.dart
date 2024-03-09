import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class KRoute {
  static final KRoute _instance = KRoute._internal();

  factory KRoute() => _instance;

  KRoute._internal();

  static Future<void> pushRemove({
    required BuildContext context,
    required Widget page,
  }) async {
    await Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute(builder: (context) => page),
      (_) => false,
    );
  }

  /// Default Duration is `800` milliseconds.
  static Future<dynamic> pushFadeAnimation({
    required BuildContext context,
    required Widget page,
    int? durationMilliseconds,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration:
            Duration(milliseconds: durationMilliseconds ?? 1500),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  static Future<void> push({
    required BuildContext context,
    required Widget page,
  }) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<void> pushNamed({
    required BuildContext context,
    required String routeName,
  }) async {
    await Navigator.pushNamed<void>(context, routeName);
  }

  static Future<void> pushNamedAndRemove({
    required BuildContext context,
    required String newRouteName,
  }) async {
    await Navigator.pushNamedAndRemoveUntil<void>(
      context,
      newRouteName,
      (_) => false,
    );
  }

  static Future<void> pushReplacement({
    required BuildContext context,
    required Widget page,
  }) async {
    await Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

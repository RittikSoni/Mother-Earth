import 'package:flutter/material.dart';

AppBar reusableAppBar(
    {required String title, List<Widget>? actions, Widget? leading}) {
  return AppBar(
    title: Text(title),
    actions: actions,
    leading: leading,
  );
}

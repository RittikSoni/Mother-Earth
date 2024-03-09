import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:flutter/material.dart';

Future<dynamic> reusableDialog({
  required String title,
  Widget? customTitleWidget,
  BuildContext? context,
  double? borderRadius,
  String? subTitle,
  String? primaryActionTitle,
  VoidCallback? primaryAction,
  String? secondaryActionTitle,
  VoidCallback? secondaryAction,
  bool? barrierDismissible,
  bool? canPop,
  bool? callPopDialog,
}) {
  return showDialog(
      context: context ?? navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop ?? true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
            ),
            title: customTitleWidget ?? Text(title),
            content: subTitle != null
                ? Text(
                    subTitle,
                    textAlign: TextAlign.center,
                  )
                : Container(),
            actions: <Widget>[
              if (primaryAction != null && secondaryAction != null) Container(),
              if (primaryAction != null || secondaryAction != null)
                Row(
                  children: <Widget>[
                    if (secondaryAction != null)
                      Expanded(
                        child: ReusableButton(
                          label: secondaryActionTitle ?? 'Cancel',
                          width: 100.0,
                          mainAxisAlignment: MainAxisAlignment.center,
                          onTap: secondaryAction,
                          fg: KTheme.appFg,
                        ),
                      ),
                    if (primaryAction != null)
                      Expanded(
                        child: ReusableButton(
                          label: primaryActionTitle ?? 'Ok',
                          width: 100.0,
                          mainAxisAlignment: MainAxisAlignment.center,
                          onTap: primaryAction,
                          bg: KTheme.globalScaffoldBG,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      });
}

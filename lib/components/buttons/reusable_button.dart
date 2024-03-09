import 'package:eco_collect/constants/ktheme.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    required this.label,
    this.onTap,
    this.bg,
    this.fg,
    this.splashColor,
    this.icon,
    this.width,
    this.buttonBorderRadius,
    this.mainAxisAlignment,
    this.insidePadding,
    this.isDisable = false,
    super.key,
    this.shadowColor,
    this.elevation,
    this.labelStyle,
    this.iconSize,
  });
  final String label;
  final IconData? icon;
  final Color? fg;

  /// Default is `KTheme.appBg`
  final Color? bg;
  final Color? splashColor;

  final Color? shadowColor;

  /// Default is `20.0`
  final double? insidePadding;
  final double? elevation;

  final TextStyle? labelStyle;

  /// Default is `double.infinity`
  final double? width;
  final double? iconSize;
  final double? buttonBorderRadius;
  final VoidCallback? onTap;

  /// Default is `spaceBetween`.
  final MainAxisAlignment? mainAxisAlignment;

  /// Default is `false`.
  final bool? isDisable;

  @override
  Widget build(BuildContext context) {
    final BorderRadius btnborderRadius =
        BorderRadius.circular(buttonBorderRadius ?? 5.0);
    return Container(
      margin: const EdgeInsets.all(5.0),
      width: width ?? double.infinity,
      child: Material(
        shadowColor: shadowColor ?? const Color.fromARGB(162, 21, 221, 235),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: btnborderRadius,
        ),
        color: isDisable! ? KTheme.disableBg : bg ?? KTheme.transparencyBlack,
        child: InkWell(
          borderRadius: btnborderRadius,
          splashColor: splashColor ?? KTheme.splashColor,
          onTap: onTap ?? () {},
          child: Padding(
            padding: EdgeInsets.all(insidePadding ?? 15.0),
            child: Row(
              mainAxisAlignment:
                  mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  label,
                  style: labelStyle ??
                      KTheme.titleTextStyle(
                        textColor: isDisable! ? KTheme.disableFg : null,
                      ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: isDisable! ? KTheme.disableFg : fg ?? KTheme.appFg,
                    size: iconSize,
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

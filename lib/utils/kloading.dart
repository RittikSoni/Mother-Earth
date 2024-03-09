import 'package:bot_toast/bot_toast.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KLoadingToast {
  static void startLoading() {
    BotToast.showCustomLoading(
      allowClick: false,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.ignore,
      toastBuilder: (cancelFunc) {
        return LottieBuilder.asset(
          KLottie.loading,
          height: KDimens.dialogImageHeight,
        );
      },
    );
  }

  static void stopLoading() {
    BotToast.closeAllLoading();
  }

  static void showToast(
      {required String msg,
      KenumToastType? toastType,
      int? durationInSeconds}) {
    BotToast.showText(
      text: msg,
      contentColor: getToastBgColor(toastType: toastType),
      onlyOne: true,
      duration: Duration(seconds: durationInSeconds ?? 2),
      clickClose: true,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.none,
    );
  }

  static void showNotification({
    required String msg,
    KenumToastType? toastType,
    int? durationInSeconds,
    bool? crossPage,
  }) {
    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) {
        return Material(
          child: ListTile(
            leading: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(1000.0),
                child:
                    LottieBuilder.asset(getToastLottie(toastType: toastType))),
            title: Text(msg),
            tileColor: getToastBgColor(toastType: toastType),
            trailing: IconButton(
              onPressed: () {
                cancelFunc.call();
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        );
      },
      onlyOne: true,
      duration: Duration(seconds: durationInSeconds ?? 2),
      crossPage: crossPage ?? true,
      backButtonBehavior: BackButtonBehavior.none,
    );
  }

  static Future<void> showCustomDialog({
    required String message,
    KenumToastType? toastType,
    bool? barrierDismissible,
    bool? canpop,
    String? buttonLabel,
    Function()? onTap,
  }) async {
    return await showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canpop ?? true,
          child: AlertDialog(
            backgroundColor: KTheme.transparencyBlack,
            title: LottieBuilder.asset(
              getToastLottie(toastType: toastType),
              height: KDimens.dialogImageHeight,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: KTheme.titleStyle,
                ),
                ReusableButton(
                  onTap: onTap ??
                      () {
                        Navigator.pop(context);
                      },
                  label: buttonLabel ?? 'Ok',
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showDialogMultipleButtons({
    required String title,
    required String subtitle,
    KenumToastType? toastType,
    bool? barrierDismissible,
    bool? canpop,
    List<Widget>? widgets,
    MainAxisAlignment? mainAxisAlignment,
  }) async {
    return await showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canpop ?? true,
          child: AlertDialog(
            backgroundColor: KTheme.transparencyBlack,
            title: LottieBuilder.asset(
              getToastLottie(toastType: toastType),
              height: KDimens.dialogImageHeight,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: KTheme.titleStyle,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: KTheme.subtitleStyle,
                ),
                widgets != null
                    ? Row(
                        mainAxisAlignment:
                            mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                        children: widgets,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showCharacterDialog({
    String? explorerImage,
    double? explorerImageHeight,
    bool? hidePrimary,
    bool? hideSecondary,
    bool? barrierDismissible,
    bool? canPop,
    String? message,
    String? title,
    String? primaryLabel,
    String? secondaryLabel,
    Function()? onPrimaryPressed,
    Function()? onSecondaryPressed,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return PopScope(
          canPop: canPop ?? true,
          child: ReusableCharacterDialog(
            explorerImage: explorerImage,
            explorerImageHeight: explorerImageHeight,
            hidePrimary: hidePrimary,
            hideSecondary: hideSecondary,
            message: message,
            onPrimaryPressed: onPrimaryPressed,
            onSecondaryPressed: onSecondaryPressed,
            primaryLabel: primaryLabel,
            secondaryLabel: secondaryLabel,
            title: title,
          ),
        );
      },
    );
  }
}

Color getToastBgColor({KenumToastType? toastType}) {
  switch (toastType) {
    case KenumToastType.success:
      return KTheme.success;

    case KenumToastType.win:
      return KTheme.success;

    case KenumToastType.lose:
      return KTheme.transparencyBlack;

    case KenumToastType.info:
      return KTheme.info;

    case KenumToastType.error:
      return KTheme.error;

    default:
      return KTheme.transparencyBlack;
  }
}

String getToastLottie({KenumToastType? toastType}) {
  switch (toastType) {
    case KenumToastType.success:
      return KLottie.confetti;

    case KenumToastType.win:
      return KLottie.confetti;

    case KenumToastType.lose:
      return KLottie.fishing3d;

    case KenumToastType.info:
      return KLottie.collection;

    case KenumToastType.error:
      return KLottie.fishing3d;

    default:
      return KLottie.collection;
  }
}

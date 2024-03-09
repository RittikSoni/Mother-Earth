import 'package:eco_collect/constants/error_handler_values.dart';

import 'package:eco_collect/utils/kloading.dart';

class ErrorHandler {
  static Exception defaultCatchError({
    required dynamic e,
    required String errorCode,
    required StackTrace stackTrace,
    String? customToastMessage,
  }) {
    KLoadingToast.showCustomDialog(
      message:
          customToastMessage ?? ErrorsHandlerValues.defaultEndUserErrorMessage,
    );
    throw Exception(e);
  }
}

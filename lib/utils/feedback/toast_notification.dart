import 'package:flutter/material.dart';
import 'package:minha_academia_front/utils/constants/colors.dart';
import 'package:minha_academia_front/utils/exceptions/exceptions.dart';
import 'package:toastification/toastification.dart';

abstract class ToastNotification {
  static void showSuccess(
    String message, {
    String? description,
    int durationSeconds = 10,
  }) {
    _showToastNotification(
      message,
      description: description,
      ToastificationType.success,
      icon: Icon(Icons.check),
      primaryColor: primaryColor,
      durationSeconds: durationSeconds,
    );
  }

  static void showError(
    String message, {
    String? description,
    int durationSeconds = 10,
  }) {
    _showToastNotification(
      message,
      description: description,
      ToastificationType.error,
      icon: Icon(Icons.error_outline),
      durationSeconds: durationSeconds,
    );
  }

  static void showErrorFromEx(
    AppException e, {
    String? description,
    int durationSeconds = 10,
  }) {
    _showToastNotification(
      e.message,
      description: description,
      ToastificationType.error,
      icon: Icon(Icons.error),
      durationSeconds: durationSeconds,
    );
  }

  static void _showToastNotification(
    String message,
    ToastificationType? type, {
    String? description,
    AlignmentGeometry? alignment,
    Widget? icon,
    bool showIcon = true,
    bool showProgressBar = true,
    Color? primaryColor,
    required int durationSeconds,
  }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: Duration(seconds: durationSeconds),
      title: Text(message),
      description: description != null
          ? RichText(text: TextSpan(text: description))
          : null,
      alignment: alignment,
      icon: icon,
      showIcon: showIcon,
      primaryColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: showProgressBar,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.onHover),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackBars {
  static failure(BuildContext context, String message,
      {Color? color, String? title}) {
    final snackBar = SnackBar(
      elevation: 0,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      content: AwesomeSnackbarContent(
        title: title ?? 'Opss!',
        message: message,
        color: color,
        contentType: ContentType.failure,
      ),
    );

    return ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static success(BuildContext context, String message,
      {Color? color, String? title, ContentType? contentType}) {
    final snackBar = SnackBar(
      elevation: 0,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      content: AwesomeSnackbarContent(
        title: title ?? 'Yay!',
        message: message,
        contentType: contentType ?? ContentType.success,
        color: color,
      ),
    );

    return ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

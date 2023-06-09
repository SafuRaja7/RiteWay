// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:riteway/configs/configs.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final Function() onPressed;
  final Color? color;
  final Color? borderColor;
  const AppButton({
    Key? key,
    required this.child,
    this.width,
    required this.onPressed,
    this.color,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: AppDimensions.normalize(19),
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? AppTheme.c!.primary,
          borderRadius: BorderRadius.circular(8.0),
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

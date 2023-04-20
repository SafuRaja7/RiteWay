// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:riteway/configs/configs.dart';

class CustomTextField extends StatefulWidget {
  final String name;
  final String? hint;
  final bool? isPass;
  final bool? enabled;
  final double? width;
  final bool isMessage;
  final int? maxLength;

  final bool? autoFocus;
  final FocusNode? node;

  final Widget? prefixIcon;
  final bool? isSuffixIcon;
  final String? initialValue;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final String? errorText;
  final String? Function(String?)? validatorFtn;
  final String? Function(String?)? onChangeFtn;

  const CustomTextField({
    Key? key,
    required this.name,
    required this.hint,
    this.isPass = false,
    this.enabled,
    this.width = double.infinity,
    this.isMessage = false,
    this.maxLength,
    this.autoFocus,
    this.node,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.initialValue,
    required this.textInputType,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.validatorFtn,
    this.onChangeFtn,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool show = false;

  @override
  void initState() {
    show = widget.isPass!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      maxLength: widget.maxLength,
      minLines: widget.isMessage ? 5 : 1,
      maxLines: widget.isMessage ? 8 : 1,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled ?? true,
      initialValue: widget.initialValue,
      name: widget.name,
      autofocus: widget.autoFocus ?? false,
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      focusNode: widget.node,
      obscureText: show,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        errorText: widget.errorText,
        prefixIcon: widget.isSuffixIcon!
            ? null
            : widget.isMessage
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: AppDimensions.normalize(28)),
                    child: widget.prefixIcon,
                  )
                : widget.prefixIcon,
        suffixIcon: widget.isPass!
            ? IconButton(
                splashRadius: AppDimensions.normalize(8),
                onPressed: () {
                  setState(() {
                    show = !show;
                  });
                },
                icon: Icon(
                  show ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  size: AppDimensions.normalize(7),
                ),
              )
            : null,
        filled: true,
        contentPadding: Space.all(0.75, 0.9),
        hintText: widget.hint,
        hintStyle: AppText.b2!.copyWith(
          color: AppTheme.c!.textSub2,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppTheme.c!.primary!,
            width: AppDimensions.normalize(0.75),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red.withAlpha(200),
            width: AppDimensions.normalize(0.75),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red.withAlpha(200),
            width: AppDimensions.normalize(0.75),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            width: AppDimensions.normalize(0.75),
            color: Colors.transparent,
          ),
        ),
      ),
      validator: widget.validatorFtn,
      onChanged: widget.onChangeFtn,
    );
  }
}

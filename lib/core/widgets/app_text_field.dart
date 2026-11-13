import 'package:flutter/material.dart';

import '../theme/ui_helpers.dart';

/// Rounded text field with icon, optional suffix and validation support.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscure = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(color: p.textPrimary, fontSize: 14.5),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 21, color: p.textFaint)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}

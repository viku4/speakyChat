import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speaky_chat/widgets/color_const.dart';

class TextFieldData {
  /// test field email

  static BuildField({
    int? minLines,
    bool? enabled,
    int? maxLines,
    TextStyle? style,
    Widget? suffixIcon,
    Widget? prefixIcon,
    InputDecoration? decoration,
    bool? readOnly,
    // bool? obscureText,
    void Function()? onTap,
    void Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    AutovalidateMode? autovalidateMode,
    String? Function(String?)? validator,
    required TextInputType keyboardType,
    required TextEditingController controller,
    Widget? label,
  }) {
    return TextFormField(
      onChanged: onChanged,
      enabled: enabled,
      onTap: onTap,
      // obscureText: obscureText ?? false,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 5,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
      controller: controller,
      style: style ??
          TextStyle(
            color: black,
          ),
      decoration: decoration ??
          InputDecoration(
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: grey),
              ),
              disabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: black)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.greenAccent),
              ),
              contentPadding: const EdgeInsets.all(10.0),
              labelStyle: TextStyle(fontSize: 14, color: grey),
              label: label,
              prefixIcon: prefixIcon,
              border: const OutlineInputBorder()),
    );
  }
}

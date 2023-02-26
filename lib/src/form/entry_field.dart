import 'package:flutter/material.dart' show TextEditingController, FocusNode, AutovalidateMode;

class EntryField<T extends Enum, V> {
  EntryField({
    required this.id,
    TextEditingController? controller,
    this.validator,
    this.asyncValidator,
    this.readOnly = false,
    this.isPure = true,
    this.fallbackValue = "",
    this.focusNode,
    this.errorText,
    this.outputConverter,
    this.isValidating = false,
    this.obscureText = false,
    this.autovalidateMode,
  }) : controller = controller ?? TextEditingController(text: fallbackValue);

  final T id;
  final bool readOnly;
  final String? Function(String)? validator;
  final Future<String?> Function(String)? asyncValidator;
  final bool isPure;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final String fallbackValue;
  final String? errorText;
  final V Function(String content)? outputConverter;
  final bool isValidating;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;

  String get text => controller.text;

  bool get isEmpty => text.isEmpty;

  bool get isNotEmpty => text.isNotEmpty;

  V get value {
    if (outputConverter != null) {
      return outputConverter!(text);
    }
    return text as V;
  }

  EntryField<T, V> copyWith({bool? readOnly, bool? isPure, String? fallbackValue,
      String? errorText, bool? isValidating, bool? obscureText}) {
    errorText ??= this.errorText;
    if(errorText == ""){
      errorText = null;
    }
    return EntryField<T, V>(
      id: id,
      controller: controller,
      asyncValidator: asyncValidator,
      validator: validator,
      errorText: errorText,
      fallbackValue: fallbackValue ?? this.fallbackValue,
      focusNode: focusNode,
      isPure: isPure ?? this.isPure,
      isValidating: isValidating ?? this.isValidating,
      outputConverter: outputConverter,
      readOnly: readOnly ?? this.readOnly,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}

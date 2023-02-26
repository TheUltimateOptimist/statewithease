import 'package:flutter/material.dart' hide FormState;
import 'package:statewithease/statewithease.dart';
import 'package:flutter/src/services/text_formatter.dart'
    show MaxLengthEnforcement, TextInputFormatter;
import 'form_state.dart';
import 'entry_field.dart';

class StateFormField<T extends Enum> extends StatelessWidget {
  StateFormField(
    this.id, {
    super.key,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
  });

  final T id;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {
    var form = context.read<FormState<T>>();
    var field = context.select<FormState<T>, EntryField<T, dynamic>>(
      (state) => state.getField(id),
    );

    return TextFormField(
      key: key,
      controller: field.controller,
      focusNode: field.focusNode,
      readOnly: field.readOnly,
      obscureText: field.obscureText,
      decoration: decoration?.copyWith(errorText: field.errorText),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      onChanged: (String newValue) {
        bool shouldValidate(AutovalidateMode? field, AutovalidateMode form) {
          if (field == null) {
            return form == AutovalidateMode.always ||
                form == AutovalidateMode.onUserInteraction;
          } else {
            return field == AutovalidateMode.always ||
                field == AutovalidateMode.onUserInteraction;
          }
        }

        FormState<T> syncValidationMapper(
            FormState<T> previous, EntryField<T, dynamic> field) {
          assert(field.validator != null);
          final newErrorText = field.validator!(field.text) ?? "";
          final newField = field.copyWith(errorText: newErrorText);
          return previous.withField(newField);
        }

        Future<FormState<T>> asyncValidationMapper(
            FormState<T> previous, EntryField<T, dynamic> field) async {
          assert(field.asyncValidator != null);
          final newErrorText = await field.asyncValidator!(field.text);
          final newField = field.copyWith(errorText: newErrorText);
          return previous.withField(newField);
        }

        onChanged ?? (newValue);
        if (!shouldValidate(field.autovalidateMode, form.autovalidateMode)) {
          return;
        }
        if (field.validator != null) {
          context.collectOne<FormState<T>, EntryField<T, dynamic>>(
              syncValidationMapper, field);
        }
        if (field.asyncValidator != null) {
          context.collectFutureOne<FormState<T>, EntryField<T, dynamic>>(
              asyncValidationMapper, field);
        }
      },
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      scrollController: scrollController,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
    );
  }
}

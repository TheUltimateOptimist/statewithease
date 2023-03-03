import 'package:flutter/material.dart';
import '../state_mapper_exceptions.dart';
import 'custom_form_state.dart';
import '../public_state_extensions.dart';
import 'submit_message.dart';

extension SubmitForm on BuildContext {
  void submitFormSync<T extends Enum>(Message? Function(Map<T, String>) valuesMapper, {void Function(BuildContext)? callback}) {
    final state = read<CustomFormState<T>>();
    if (state.validate()) {
      collect(
        (CustomFormState<T> state) {
          final message = valuesMapper(state.values);
          if (message != null) {
            return state.withMessage(message);
          }
          throw IgnoreState();
        },
        callback: callback,
      );
    }
  }

  void submitFormAsync<T extends Enum>(Future<Message?> Function(Map<T, String>) valuesMapper, {void Function(BuildContext)? callback}) {
    final state = read<CustomFormState<T>>();
    if (state.validate()) {
      if (state.message != null) {
        collect((CustomFormState<T> state) => state.withMessage(null));
      }
      collectFuture(
        (CustomFormState<T> state) async {
          final message = await valuesMapper(state.values);
          if (message != null) {
            return state.withMessage(message);
          }
          throw IgnoreState();
        },
        callback: callback,
      );
    }
  }

  bool isSubmitting<T extends Enum>() => isLoading<CustomFormState<T>>();
}

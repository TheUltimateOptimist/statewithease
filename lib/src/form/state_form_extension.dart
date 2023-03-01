import 'package:flutter/material.dart';
import '../state_mapper_exceptions.dart';
import 'custom_form_state.dart';
import '../public_state_extensions.dart';

extension SubmitForm on BuildContext {
  void submitFormSync<T extends Enum>(String? Function(Map<T, String>) valuesMapper, {void Function(BuildContext)? callback}) {
    final state = read<CustomFormState<T>>();
    if (state.validate()) {
      collect(
        (CustomFormState<T> state) {
          final errorMessage = valuesMapper(state.values);
          if (errorMessage != null) {
            return state.withSubmitErrorMessage(errorMessage);
          }
          throw IgnoreState();
        },
        callback: callback,
      );
    }
  }

  void submitFormAsync<T extends Enum>(Future<String?> Function(Map<T, String>) valuesMapper, {void Function(BuildContext)? callback}) {
    final state = read<CustomFormState<T>>();
    if (state.validate()) {
      if (state.submitErrorMessage != null) {
        collect((CustomFormState<T> state) => state.withSubmitErrorMessage(null));
      }
      collectFuture(
        (CustomFormState<T> state) async {
          final errorMessage = await valuesMapper(state.values);
          if (errorMessage != null) {
            return state.withSubmitErrorMessage(errorMessage);
          }
          throw IgnoreState();
        },
        callback: callback,
      );
    }
  }

  bool isSubmitting<T extends Enum>() => isLoading<CustomFormState<T>>();
}

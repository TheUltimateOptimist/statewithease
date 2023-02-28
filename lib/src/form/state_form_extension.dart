import 'package:flutter/material.dart';
import 'custom_form_state.dart';
import '../public_state_extensions.dart';

extension SubmitForm on BuildContext{
  void submitFormSync<T extends Enum>(CustomFormState<T> Function(CustomFormState<T>) stateMapper, {void Function(BuildContext)? callback}){
    final state = read<CustomFormState<T>>();
    if(state.validate()){
      collect(stateMapper, callback: callback);
    }
  }

  void submitFormAsync<T extends Enum>(Future<CustomFormState<T>> Function(CustomFormState<T>) stateMapper, {void Function(BuildContext)? callback}){
    final state = read<CustomFormState<T>>();
    if(state.validate()){
      if(state.submitErrorMessage != null){
        collect((CustomFormState<T> state) => state.withSubmitErrorMessage(null));
      }
      collectFuture(stateMapper, callback: callback);
    }
  }

  bool isSubmitting<T extends Enum>() => isLoading<CustomFormState<T>>();
}
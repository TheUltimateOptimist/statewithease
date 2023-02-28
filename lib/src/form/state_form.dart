import 'package:flutter/material.dart';
import 'package:statewithease/statewithease.dart';

class StateForm<T extends Enum> extends StatelessWidget {
  const StateForm(
    this.fields, {
    required this.child,
    this.onWillPop,
    this.onChanged,

    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final List<T> fields;
  final Widget child;
  final Future<bool> Function()? onWillPop;
  final void Function()? onChanged;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final state = CustomFormState(fields);
    return StateProvider<CustomFormState<T>>(
      state,
      child: Builder(
        builder: (context) {
          return Form(
            key: state.formKey,
            child: child,
            onWillPop: onWillPop,
            onChanged: onChanged,
            autovalidateMode: autovalidateMode,
          );
        }
      ),
    );
  }
}

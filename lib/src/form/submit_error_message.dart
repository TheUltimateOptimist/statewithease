import 'package:flutter/material.dart';
import '../public_state_extensions.dart';
import 'custom_form_state.dart';

class SubmitErrorMessage<T extends Enum> extends StatelessWidget{
  const SubmitErrorMessage({Key? key, required this.builder});

  final Widget Function(BuildContext context, String? message) builder;

  @override
  Widget build(BuildContext context) {
    final submitErrorMessage = context.select<CustomFormState<T>, String?>((state) => state.submitErrorMessage);
    return builder(context, submitErrorMessage);
  }

}
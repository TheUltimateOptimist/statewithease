import 'package:flutter/material.dart';
import '../public_state_extensions.dart';
import 'custom_form_state.dart';

enum MessageCategory{
  success,
  error
}

class Message{
  Message({required this.category, required this.text});

  final MessageCategory category;
  final String text;
}

class SubmitMessage<T extends Enum> extends StatelessWidget{
  const SubmitMessage({Key? key, required this.builder});

  final Widget Function(BuildContext context, Message? message) builder;

  @override
  Widget build(BuildContext context) {
    final message = context.select<CustomFormState<T>, Message?>((state) => state.message);
    return builder(context, message);
  }

}
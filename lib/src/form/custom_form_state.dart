import 'package:flutter/material.dart';

class CustomFormState<T extends Enum>{
  CustomFormState(this.fields) : submitErrorMessage = null, formKey = GlobalKey<FormState>(), _controllers = Map.fromEntries(fields.map((id) => MapEntry(id, TextEditingController())));

  final List<T> fields;
  final Map<T, TextEditingController> _controllers;
  final String? submitErrorMessage;
  final GlobalKey<FormState> formKey;

  CustomFormState.internal(this.fields, this._controllers, this.submitErrorMessage, this.formKey);

  Map<T, String> get values => _controllers.map((key, value) => MapEntry(key, value.text));

  String getValue(T id) => _controllers[id]!.text;

  TextEditingController getController(T id) => _controllers[id]!;

  bool validate() => formKey.currentState!.validate();

  void reset() => formKey.currentState!.reset();

  CustomFormState<T> withSubmitErrorMessage(String? newSubmitErrorMessage){
    return CustomFormState.internal(fields, _controllers, newSubmitErrorMessage, formKey);
  }
}
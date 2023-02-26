import 'package:flutter/material.dart' show AutovalidateMode;

import 'entry_field.dart';

class FormState<T extends Enum> {
  FormState(
    this.fields, {
    this.autovalidateMode = AutovalidateMode.disabled,
    this.outputConverter,
    this.submitErrorMessage,
  });

  final List<EntryField<T, dynamic>> fields;
  final AutovalidateMode autovalidateMode;
  final dynamic Function(Map<T, dynamic>)? outputConverter;
  final String? submitErrorMessage;

  FormState<T> copyWith({List<EntryField<T, dynamic>>? fields, String? submitErrorMessage}){
    return FormState<T>(fields ?? this.fields, submitErrorMessage: submitErrorMessage,autovalidateMode: autovalidateMode, outputConverter: outputConverter, );
  }

  EntryField<T, dynamic> getField(T id) => fields.singleWhere((field) => field.id == id);
  
  FormState<T> withField(EntryField<T, dynamic> newField){
    assert(fields.where((field) => field.id == newField.id).length == 1);
    var index = fields.indexWhere((field) => field.id == newField.id);
    var newFields = List<EntryField<T, dynamic>>.from(fields);
    newFields[index] = newField;
    return copyWith(fields: newFields);
  }

  dynamic get value{
    var values = <T, dynamic>{};
    for (var field in fields) {
      values.putIfAbsent(field.id, () => field.value);
    }
    if(outputConverter !=  null){
      return outputConverter!(values);
    }
    return values;
  }
}

import 'package:flutter/material.dart';

import 'provided_state.dart';

extension PrivateStateExtension on BuildContext{
  bool Function(dynamic, dynamic) get alwaysRebuild {
    return (dynamic _, dynamic __) => true;
  }

  bool Function(dynamic, dynamic) get neverRebuild {
    return (dynamic _, dynamic __) => false;
  }

  bool Function(dynamic, dynamic) get rebuildAfterStateChange {
    return (dynamic previous, dynamic current) => previous != current;
  }

  bool Function(dynamic, dynamic) get rebuildAfterisLoadingChange {
    return (dynamic previous, dynamic current) => previous == current;
  }

  ProvidedState getProvidedState<T>(bool Function(dynamic, dynamic) aspect) {
    final providedState =
        InheritedModel.inheritFrom<ProvidedState<ShouldRebuildCallback<T>>>(
            this,
            aspect: aspect);
    if (providedState == null) {
      throw Exception(
          "No StateProvider<$T> could be found in the current BuildContext. Please make sure to wrap the section of the widget tree in which you want to use it with StateProvider<$T>.");
    }
    return providedState;
  }
}
import 'package:flutter/material.dart';

import 'state_model.dart';

extension PrivateStateExtension on BuildContext{
  bool Function(WrappedState, WrappedState) get alwaysRebuild {
    return (WrappedState _, WrappedState __) => true;
  }

  bool Function(WrappedState, WrappedState) get neverRebuild {
    return (WrappedState _, WrappedState __) => false;
  }

  bool Function(WrappedState, WrappedState) get rebuildAfterStateChange {
    return (WrappedState previous, WrappedState current) => previous.state != current.state;
  }

  bool Function(WrappedState, WrappedState) get rebuildAfterisLoadingChange {
    return (WrappedState previous, WrappedState current) => previous.isLoading != current.isLoading;
  }

  StateModel<ShouldRebuildCallback<T>> getStateModel<T>(bool Function(WrappedState, WrappedState) aspect) {
    final stateModel =
        InheritedModel.inheritFrom<StateModel<ShouldRebuildCallback<T>>>(
            this,
            aspect: aspect);
    if (stateModel == null) {
      throw Exception(
          "No StateProvider<$T> could be found in the current BuildContext. Please make sure to wrap the section of the widget tree in which you want to use it with StateProvider<$T>.");
    }
    return stateModel;
  }

  WrappedState<T> getWrappedState<T>(bool Function(WrappedState, WrappedState) aspect){
    return getStateModel<T>(aspect).wrappedState as WrappedState<T>;
  }

  T getState<T>(bool Function(WrappedState, WrappedState) aspect){
    return getWrappedState<T>(aspect).state;
  }
}
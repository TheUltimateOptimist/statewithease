import 'package:flutter/material.dart';

typedef ShouldRebuildCallback<T> = bool Function(
    WrappedState<T> oldWrappedState, WrappedState<T> newWrappedState);

class WrappedState<T> {
  final bool isLoading;
  final T state;
  WrappedState({
    required this.isLoading,
    required this.state,
  });

  WrappedState<T> newisLoading(bool newIsLoading) {
    return WrappedState(isLoading: newIsLoading, state: state);
  }

  WrappedState<T> newState(T newState) {
    return WrappedState(isLoading: isLoading, state: newState);
  }
}

class StateModel<T> extends InheritedModel<T> {
  StateModel({
    required super.child,
    required this.wrappedState,
    required this.collect,
    required this.startLoading,
  });

  final WrappedState wrappedState;
  final void Function(Object? newState) collect;
  final void Function() startLoading;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget as StateModel<T>;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant InheritedModel oldWidget, Set<T> dependencies) {
    var oldProvidedState = oldWidget as StateModel<T>;
    for (var shouldRebuildCallback in dependencies) {
      if ((shouldRebuildCallback as ShouldRebuildCallback<dynamic>)(
          oldProvidedState.wrappedState, wrappedState)) {
        return true;
      }
    }
    return false;
  }
}

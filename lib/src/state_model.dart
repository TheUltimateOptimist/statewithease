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
    required this.collectState,
    required this.collectStateStream,
    required this.collectIsLoading,
    required this.registerListener,
  });

  final WrappedState wrappedState;
  final void Function(Object? newState) collectState;
  final void Function(dynamic stateStream) collectStateStream;
  final void Function(bool isLoading) collectIsLoading;
  final void Function(void Function(WrappedState previous, WrappedState current) listener) registerListener;

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

import 'package:flutter/material.dart';

class ProvidedState<T> extends InheritedWidget {
  const ProvidedState({
    super.key,
    required super.child,
    required this.state,
    required this.isLoading,
    required this.collect,
    required this.startLoading,
  });

  final T state;
  final bool isLoading;
  final void Function(T newState) collect;
  final void Function() startLoading;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget as ProvidedState;
  }
}
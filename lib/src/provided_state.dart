import 'package:flutter/material.dart';

typedef ShouldRebuildCallback<T> = bool Function(
    T oldState, T newState);

// class ProvidedState<T> extends InheritedWidget {
//   const ProvidedState({
//     super.key,
//     required super.child,
//     required this.state,
//     required this.isLoading,
//     required this.collect,
//     required this.startLoading,
//   });

//   final T state;
//   final bool isLoading;
//   final void Function(T newState) collect;
//   final void Function() startLoading;

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return this != oldWidget as ProvidedState;
//   }
// }

class ProvidedState<T> extends InheritedModel<T> {
  ProvidedState({
    required super.child,
    required this.state,
    required this.isLoading,
    required this.collect,
    required this.startLoading,
  });

  final Object? state;
  final bool isLoading;
  final void Function(Object? newState) collect;
  final void Function() startLoading;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget as ProvidedState<T>;
  }

  @override
  bool updateShouldNotifyDependent(covariant InheritedModel oldWidget, Set<T> dependencies) {
    var oldProvidedState = oldWidget as ProvidedState<T>;
    if(oldProvidedState.isLoading != isLoading){
      return true;
    }
    for(var shouldRebuildCallback in dependencies){
      if((shouldRebuildCallback as ShouldRebuildCallback<Object?>)(oldProvidedState.state, state)){
        return true;
      }
    }
    return false;
  }
}

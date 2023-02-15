import 'package:flutter/material.dart';

import 'provided_state.dart';

extension StateExtension on BuildContext {
  ProvidedState<T> _getProvidedState<T>() {
    final providedState = dependOnInheritedWidgetOfExactType<ProvidedState<T>>();
    if (providedState == null) {
      throw Exception(
          "No StateProvider<$T> could be found in the current BuildContext. Please make sure to wrap the section of the widget tree in which you want to use it with StateProvider<$T>.");
    }
    return providedState;
  }

  T state<T>() => _getProvidedState<T>().state;

  bool isLoading<T>() => _getProvidedState<T>().isLoading;
  

  void collect<T>(T Function(T state) stateMapper) {
    final appState = _getProvidedState<T>();
    final newState = stateMapper(appState.state);
    appState.collect(newState);
  }

  Future<void> collectFuture<T>(Future<T> Function(T state) stateMapper) async{
    final providedState = _getProvidedState<T>();
    providedState.startLoading();
    final newState = await stateMapper(providedState.state);
    providedState.collect(newState);
  }
}
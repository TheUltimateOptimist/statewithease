import 'package:flutter/material.dart';

import 'provided_state.dart';

extension StateExtension on BuildContext {
  bool Function(Object?, Object?) get _alwaysRebuild{
    return (Object? _, Object? __) => true;
  }

  bool Function(Object?, Object?) get _neverRebuild{
    return (Object? _, Object? __) => false;
  }

  ProvidedState _getProvidedState<T>(bool Function(Object?, Object?) aspect) {
    final providedState = InheritedModel.inheritFrom<ProvidedState<ShouldRebuildCallback<T>>>(this, aspect: aspect);
    if (providedState == null) {
      throw Exception(
          "No StateProvider<$T> could be found in the current BuildContext. Please make sure to wrap the section of the widget tree in which you want to use it with StateProvider<$T>.");
    }
    return providedState;
  }

  bool isLoading<T>() => _getProvidedState<T>(_alwaysRebuild).isLoading;

  T watch<T>() => _getProvidedState<T>(_alwaysRebuild).state as T;

  R select<T, R>(R Function(T state) selector){
    final providedState = _getProvidedState<T>((p0, p1){
      T oldState = p0 as T;
      T newState = p1 as T;
      if(selector(oldState) != selector(newState)){
        return true;
      }
      return false;
    });
    return selector(providedState.state as T);
  }

  T read<T>() => _getProvidedState<T>(_neverRebuild).state as T;

  void collect<T>(T Function(T state) stateMapper) {
    final appState = _getProvidedState<T>(_neverRebuild);
    final newState = stateMapper(appState.state as T);
    appState.collect(newState);
  }

  Future<void> collectFuture<T>(Future<T> Function(T state) stateMapper) async{
    final providedState = _getProvidedState<T>(_neverRebuild);
    providedState.startLoading();
    final newState = await stateMapper(providedState.state as T);
    providedState.collect(newState);
  }
}
import 'package:flutter/material.dart';

import 'provided_state.dart';

class Ignore {
  const Ignore();
}

extension StateExtension on BuildContext {
  bool Function(Object?, Object?) get _alwaysRebuild {
    return (Object? _, Object? __) => true;
  }

  bool Function(Object?, Object?) get _neverRebuild {
    return (Object? _, Object? __) => false;
  }

  ProvidedState _getProvidedState<T>(bool Function(Object?, Object?) aspect) {
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

  bool isLoading<T>() => _getProvidedState<T>(_alwaysRebuild).isLoading;

  T watch<T>() => _getProvidedState<T>(_alwaysRebuild).state as T;

  R select<T, R>(R Function(T state) selector) {
    final providedState = _getProvidedState<T>((p0, p1) {
      T oldState = p0 as T;
      T newState = p1 as T;
      if (selector(oldState) != selector(newState)) {
        return true;
      }
      return false;
    });
    return selector(providedState.state as T);
  }

  T read<T>() => _getProvidedState<T>(_neverRebuild).state as T;

  Future<void> collect<T>(
    dynamic stateMapper, [
    dynamic extra = const Ignore(),
    dynamic secondExtra = const Ignore(),
    dynamic thirdExtra = const Ignore(),
  ]) async {
    final appState = _getProvidedState<T>(_neverRebuild);
    final dynamic newState;
    if (extra is Ignore) {
      assert(stateMapper is T Function(T));
      newState = stateMapper(appState.state);
    } else if (secondExtra is Ignore) {
      newState = stateMapper(appState.state, extra);
    } else if (thirdExtra is Ignore) {
      newState = stateMapper(appState.state, extra, secondExtra);
    } else {
      newState = stateMapper(appState.state, extra, secondExtra, thirdExtra);
    }
    assert(newState is T || newState is Future<T>);
    appState.collect(await newState);
  }
}

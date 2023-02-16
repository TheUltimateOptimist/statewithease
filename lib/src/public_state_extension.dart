import 'package:flutter/material.dart';

import 'private_state_extension.dart';

class Ignore {
  const Ignore();
}

extension PublicStateExtension on BuildContext {
  bool isLoading<T>() => getProvidedState<T>(rebuildAfterisLoadingChange).isLoading;

  T watch<T>() => getProvidedState<T>(rebuildAfterStateChange).state as T;

  R select<T, R>(R Function(T state) selector) {
    final providedState = getProvidedState<T>((p0, p1) {
      T oldState = p0 as T;
      T newState = p1 as T;
      if (selector(oldState) != selector(newState)) {
        return true;
      }
      return false;
    });
    return selector(providedState.state as T);
  }

  T read<T>() => getProvidedState<T>(neverRebuild).state as T;

  Future<void> collect<T>(
    dynamic stateMapper, [
    dynamic extra = const Ignore(),
    dynamic secondExtra = const Ignore(),
    dynamic thirdExtra = const Ignore(),
  ]) async {
    final appState = getProvidedState<T>(neverRebuild);
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
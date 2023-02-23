import 'package:flutter/material.dart';

import 'private_state_extension.dart';

class Ignore {
  const Ignore();
}

extension PublicStateExtension on BuildContext {
  bool isLoading<T>() => getWrappedState<T>(rebuildAfterisLoadingChange).isLoading;

  T watch<T>() => getState<T>(rebuildAfterStateChange);

  R select<T, R>(R Function(T state) selector) {
    final state = getState<T>((p0, p1) {
      T oldState = p0.state;
      T newState = p1.state;
      if (selector(oldState) != selector(newState)) {
        return true;
      }
      return false;
    });
    return selector(state);
  }

  T read<T>() => getWrappedState<T>(neverRebuild).state;

  Future<void> collect<T>(
    dynamic stateMapper, [
    dynamic extra = const Ignore(),
    dynamic secondExtra = const Ignore(),
    dynamic thirdExtra = const Ignore(),
  ]) async {
    final stateModel = getStateModel<T>(neverRebuild);
    final dynamic newState;
    if (extra is Ignore) {
      assert(stateMapper is T Function(T));
      newState = stateMapper(stateModel.wrappedState.state);
    } else if (secondExtra is Ignore) {
      newState = stateMapper(stateModel.wrappedState.state, extra);
    } else if (thirdExtra is Ignore) {
      newState = stateMapper(stateModel.wrappedState.state, extra, secondExtra);
    } else {
      newState = stateMapper(stateModel.wrappedState.state, extra, secondExtra, thirdExtra);
    }
    assert(newState is T || newState is Future<T>);
    stateModel.collect(await newState);
  }
}
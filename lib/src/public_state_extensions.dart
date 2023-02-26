import 'package:flutter/material.dart';

import 'private_state_extension.dart';

class Ignore {
  const Ignore();
}

extension ReadExtension on BuildContext{
  T read<T>() => getWrappedState<T>(neverRebuild).state;
}

extension WatchExtension on BuildContext{
  T watch<T>() => getState<T>(rebuildAfterStateChange);
}

extension SelectExtension on BuildContext{
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
}

extension IsLoadingExtension on BuildContext{
  bool isLoading<T>() => getWrappedState<T>(rebuildAfterisLoadingChange).isLoading;
}

extension CollectExtension on BuildContext{
  void collect<T>(T Function(T) stateMapper){
    final stateModel = getStateModel<T>(neverRebuild);
    final newState = stateMapper(stateModel.wrappedState.state);
    stateModel.collect(newState);
  }
}

extension CollectOneExtension on BuildContext{
  void collectOne<T, P1>(T Function(T, P1) stateMapper, P1 param1){
    final stateModel = getStateModel<T>(neverRebuild);
    final newState = stateMapper(stateModel.wrappedState.state, param1);
    stateModel.collect(newState);
  }
}

extension CollectTwoExtension on BuildContext{
  void collectTwo<T, P1, P2>(T Function(T, P1, P2) stateMapper, P1 param1, P2 param2){
    final stateModel = getStateModel<T>(neverRebuild);
    final newState = stateMapper(stateModel.wrappedState.state, param1, param2);
    stateModel.collect(newState);
  }
}

extension CollectFutureExtension on BuildContext{
  Future<void> collectFuture<T>(Future<T> Function(T) stateMapper) async{
    final stateModel = getStateModel<T>(neverRebuild);
    stateModel.startLoading();
    final newState = await stateMapper(stateModel.wrappedState.state);
    stateModel.collect(newState);
  }
}

extension CollectFutureOneExtension on BuildContext{
  Future<void> collectFutureOne<T, P1>(Future<T> Function(T, P1) stateMapper, P1 param1) async{
    final stateModel = getStateModel<T>(neverRebuild);
    stateModel.startLoading();
    final newState = await stateMapper(stateModel.wrappedState.state, param1);
    stateModel.collect(newState);
  }
}

extension CollectFutureTwoExtension on BuildContext{
  Future<void> collectFutureTwo<T, P1, P2>(Future<T> Function(T, P1, P2) stateMapper, P1 param1, P2 param2) async{
    final stateModel = getStateModel<T>(neverRebuild);
    stateModel.startLoading();
    final newState = await stateMapper(stateModel.wrappedState.state, param1, param2);
    stateModel.collect(newState);
  }
}
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
  void collect<T>(T Function(T) stateMapper, {void Function(BuildContext)? callback}){
    collectInternalSync<T>((state) => stateMapper(state), callback);
  }
}

extension CollectOneExtension on BuildContext{
  void collectOne<T, P1>(T Function(T, P1) stateMapper, P1 param1, {void Function(BuildContext)? callback}){
    collectInternalSync<T>((state) => stateMapper(state, param1), callback);
  }
}

extension CollectTwoExtension on BuildContext{
  void collectTwo<T, P1, P2>(T Function(T, P1, P2) stateMapper, P1 param1, P2 param2, {void Function(BuildContext)? callback}){
    collectInternalSync<T>((state) => stateMapper(state, param1, param2), callback);
  }
}

extension CollectFutureExtension on BuildContext{
  Future<void> collectFuture<T>(Future<T> Function(T) stateMapper, {void Function(BuildContext)? callback}) async{
    await collectInternalAsync<T>((state) async => await stateMapper(state), callback);
  }
}

extension CollectFutureOneExtension on BuildContext{
  Future<void> collectFutureOne<T, P1>(Future<T> Function(T, P1) stateMapper, P1 param1, {void Function(BuildContext)? callback}) async{
    await collectInternalAsync<T>((state) async => await stateMapper(state, param1), callback);
  }
}

extension CollectFutureTwoExtension on BuildContext{
  Future<void> collectFutureTwo<T, P1, P2>(Future<T> Function(T, P1, P2) stateMapper, P1 param1, P2 param2, {void Function(BuildContext)? callback}) async{
    await collectInternalAsync<T>((state) async => await stateMapper(state, param1, param2), callback);
  }
}
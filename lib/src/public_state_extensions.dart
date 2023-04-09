import 'package:flutter/material.dart';
import 'private_state_extension.dart';
import 'state_stream.dart';

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

extension CollectStateStreamExtension on BuildContext{
  void collectStateStream<T>(StateStream<T> Function(T) getStateStream, {void Function(BuildContext)? callback}) {
    collectInternalStateStream<T>((state) => getStateStream(state), callback);
  }
}

extension CollectStateStreamOneExtension on BuildContext{
  void collectStateStreamOne<T, P1>(StateStream<T> Function(T, P1) getStateStream, P1 param1, {void Function(BuildContext)? callback}) {
    collectInternalStateStream<T>((state) => getStateStream(state, param1), callback);
  }
}

extension CollectStateStreamTwoExtension on BuildContext{
  void collectStateStreamTwo<T, P1, P2>(StateStream<T> Function(T, P1, P2) getStateStream, P1 param1, P2 param2, {void Function(BuildContext)? callback}) {
    collectInternalStateStream<T>((state) => getStateStream(state, param1, param2), callback);
  }
}

extension CollectFutureStateStreamExtension on BuildContext{
  void collectFutureStateStream<T>(Future<StateStream<T>> Function(T) getStateStream, {void Function(BuildContext)? callback}) async{
    collectInternalStateStreamAsync<T>((state) => getStateStream(state), callback);
  }
}

extension CollectFutureStateStreamOneExtension on BuildContext{
  void collectFutureStateStreamOne<T, P1>(Future<StateStream<T>> Function(T, P1) getStateStream, P1 param1, {void Function(BuildContext)? callback}) async{
    collectInternalStateStreamAsync<T>((state) => getStateStream(state, param1), callback);
  }
}

extension CollectFutureStateStreamTwoExtension on BuildContext{
  void collectFutureStateStreamTwo<T, P1, P2>(Future<StateStream<T>> Function(T, P1, P2) getStateStream, P1 param1, P2 param2, {void Function(BuildContext)? callback}) async{
    collectInternalStateStreamAsync<T>((state) => getStateStream(state, param1, param2), callback);
  }
}
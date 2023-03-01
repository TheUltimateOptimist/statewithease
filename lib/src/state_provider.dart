import 'dart:async';

import 'package:flutter/material.dart';
import 'state_model.dart';

class StateProvider<T> extends StatefulWidget {
  const StateProvider(
    this.initial, {
    super.key,
    this.future,
    this.stream,
    this.mapperStream,
    required this.child,
  }) : assert((future == null || stream == null) && (future == null || mapperStream == null)) ;

  final T initial;
  final Future<T>? future;
  final Stream<T>? stream;
  final Stream<T Function(T)>? mapperStream;
  final Widget child;

  @override
  State<StateProvider<T>> createState() => _StateProviderState();
}

class _StateProviderState<T> extends State<StateProvider<T>> {
  late ValueNotifier<WrappedState<T>> _wrappedStateNotifier;
  StreamSubscription<T Function(T)>? _mapperStreamSubscription;
  StreamSubscription<T>? _stateStreamSubscription;

  @override
  void dispose() {
    _mapperStreamSubscription?.cancel();
    _stateStreamSubscription?.cancel();
    _wrappedStateNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var isLoading = false;
    if(widget.future != null || widget.stream != null || widget.mapperStream != null){
      isLoading = true;
    }
    _wrappedStateNotifier = ValueNotifier(WrappedState(isLoading: isLoading, state: widget.initial));
   
    if(widget.future != null){
      firstLoad();
    }
    
    if(widget.stream != null){
      _stateStreamSubscription = widget.stream!.listen((state) {
        collectState(state);
      });
    }

    if(widget.mapperStream != null){
      _mapperStreamSubscription = widget.mapperStream!.listen((stateMapper) {
        collectState(stateMapper(_wrappedStateNotifier.value.state));
      });
    }
    super.initState();
  }

  Future<void> firstLoad() async{
    final loadedState = await widget.future;
    collectState(loadedState);
  }

  void collectState(Object? newState) {
    _wrappedStateNotifier.value = WrappedState(isLoading: false, state: newState as T);
  }

  void collectIsLoading(bool isLoading) {
    _wrappedStateNotifier.value = WrappedState(isLoading: isLoading, state: _wrappedStateNotifier.value.state);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _wrappedStateNotifier,
      builder: (context, value, _) {
        return StateModel<ShouldRebuildCallback<T>>(
          wrappedState: value,
          collectState: collectState,
          collectIsLoading: collectIsLoading,
          child: widget.child,
        );
      }
    );
  }
}

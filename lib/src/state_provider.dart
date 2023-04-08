import 'dart:async';

import 'package:flutter/material.dart';
import 'state_stream.dart';
import 'state_model.dart';

class StateProvider<T> extends StatefulWidget {
  const StateProvider(
    this.initial, {
    super.key,
    this.future,
    this.stateStreams,
    required this.child,
  });

  final T initial;
  final Future<T>? future;
  final List<StateStream<T>>? stateStreams;
  final Widget child;

  @override
  State<StateProvider<T>> createState() => _StateProviderState();
}

class _StateProviderState<T> extends State<StateProvider<T>> {
  late WrappedState<T> _previousState;
  late ValueNotifier<WrappedState<T>> _wrappedStateNotifier;
  final List<StreamSubscription> _anonymousStreamSubscriptions = List.empty(growable: true);

  @override
  void dispose() {
    for (var subscription in _anonymousStreamSubscriptions) {
      subscription.cancel();
    }
    _wrappedStateNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var isLoading = false;
    if (widget.future != null) {
      isLoading = true;
    }
    _wrappedStateNotifier = ValueNotifier(WrappedState(isLoading: isLoading, state: widget.initial));
    if (widget.future != null) {
      firstLoad();
    }
    if(widget.stateStreams != null){
      for(final stateStream in widget.stateStreams!){
        collectStateStream(stateStream);
      }
    }
    super.initState();
  }

  Future<void> firstLoad() async {
    final loadedState = await widget.future;
    collectState(loadedState);
  }

  void collectState(Object? newState) {
    _previousState = _wrappedStateNotifier.value;
    _wrappedStateNotifier.value = WrappedState(isLoading: false, state: newState as T);
  }

  void collectStateStream(StateStream stateStream) {
    final streamSubcription = stateStream.stream.listen((stateMapper) {
      collectState(stateMapper(_wrappedStateNotifier.value.state));
    });
    if(stateStream.assign != null){
      stateStream.assign!(_wrappedStateNotifier.value.state, streamSubcription);
    }
    else{
      _anonymousStreamSubscriptions.add(streamSubcription);
    }
  }

  void collectIsLoading(bool isLoading) {
    _previousState = _wrappedStateNotifier.value;
    _wrappedStateNotifier.value = WrappedState(isLoading: isLoading, state: _wrappedStateNotifier.value.state);
  }

  void registerListener(void Function(WrappedState<T> previous, WrappedState<T> current) listener) {
    _wrappedStateNotifier.addListener(() {
      listener(_previousState, _wrappedStateNotifier.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _wrappedStateNotifier,
        builder: (context, value, _) {
          return StateModel<ShouldRebuildCallback<T>>(
            wrappedState: value,
            collectState: collectState,
            collectStateStream: collectStateStream,
            collectIsLoading: collectIsLoading,
            registerListener: registerListener,
            child: widget.child,
          );
        });
  }
}

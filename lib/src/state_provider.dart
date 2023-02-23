import 'dart:async';

import 'package:flutter/material.dart';
import 'state_model.dart';

class StateProvider<T> extends StatefulWidget {
  const StateProvider(
    this.initial, {
    super.key,
    this.future,
    this.stream,
    required this.child,
  }) : assert(future == null || stream == null);

  final T initial;
  final Future<T>? future;
  final Stream<T Function(T)>? stream;
  final Widget child;

  @override
  State<StateProvider<T>> createState() => _StateProviderState();
}

class _StateProviderState<T> extends State<StateProvider<T>> {
  late T _state;
  bool _isLoading = false;
  StreamSubscription<T Function(T)>? _streamSubscription;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _state = widget.initial;
    if(widget.future != null){
      _isLoading = true;
      firstLoad();
    }
    if(widget.stream != null){
      _isLoading = true;
      _streamSubscription = widget.stream!.listen((stateMapper) {
        setState(() {
          _isLoading = false;
          _state = stateMapper(_state);
        });
      });
    }
    super.initState();
  }

  Future<void> firstLoad() async{
    final loadedState = await widget.future;
    collect(loadedState);
  }

  void collect(Object? newState) {
    setState(() {
      _state = newState as T;
      _isLoading = false;
    });
  }

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StateModel<ShouldRebuildCallback<T>>(
      wrappedState: WrappedState<T>(isLoading: _isLoading, state: _state),
      collect: collect,
      startLoading: startLoading,
      child: widget.child,
    );
  }
}

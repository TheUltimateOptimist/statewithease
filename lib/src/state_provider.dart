import 'dart:async';

import 'package:flutter/material.dart';
import 'provided_state.dart';

class StateProvider<T> extends StatefulWidget {
  const StateProvider(
    this.initial, {
    super.key,
    this.future,
    required this.child,
  });

  final T Function() initial;
  final Future<T> Function()? future;
  final Widget child;

  @override
  State<StateProvider<T>> createState() => _StateProviderState();
}

class _StateProviderState<T> extends State<StateProvider<T>> {
  late T _state;
  bool _isLoading = false;
  StreamSubscription<T>? _streamSubscription;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _state = widget.initial();
    if(widget.future != null){
      _isLoading = true;
      firstLoad();
    }
    super.initState();
  }

  Future<void> firstLoad() async{
    final loadedState = await widget.future!();
    collect(loadedState);
  }

  void collect(T newState) {
    setState(() {
      _state = newState;
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
    return ProvidedState<T>(
      state: _state,
      isLoading: _isLoading,
      collect: collect,
      startLoading: startLoading,
      child: widget.child,
    );
  }
}
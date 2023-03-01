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
  late T _state;
  bool _isLoading = false;
  StreamSubscription<T Function(T)>? _mapperStreamSubscription;
  StreamSubscription<T>? _stateStreamSubscription;

  @override
  void dispose() {
    _mapperStreamSubscription?.cancel();
    _stateStreamSubscription?.cancel();
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
      _stateStreamSubscription = widget.stream!.listen((state) {
        setState(() {
          _isLoading = false;
          _state = state;
        });
      });
    }
    if(widget.mapperStream != null){
      _isLoading = true;
      _mapperStreamSubscription = widget.mapperStream!.listen((stateMapper) {
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
    collectState(loadedState);
  }

  void collectState(Object? newState) {
    setState(() {
      _state = newState as T;
      _isLoading = false;
    });
  }

  void collectIsLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StateModel<ShouldRebuildCallback<T>>(
      wrappedState: WrappedState<T>(isLoading: _isLoading, state: _state),
      collectState: collectState,
      collectIsLoading: collectIsLoading,
      child: widget.child,
    );
  }
}

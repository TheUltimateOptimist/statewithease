import 'package:flutter/material.dart';
import 'public_state_extension.dart';
import 'private_state_extension.dart';
import 'state_model.dart';

class StateBuilder<T> extends StatelessWidget {
  const StateBuilder({super.key, required this.builder, this.buildWhen});

  final Widget Function(BuildContext, T state) builder;
  final bool Function(T previous, T current)? buildWhen;

  bool _convertedBuildWhen(WrappedState previous, WrappedState current){
    return buildWhen!(previous.state, current.state);
  }

  @override
  Widget build(BuildContext context) {
    final T state;
    if(buildWhen == null){
      state = context.watch<T>();
    }
    else{
      state = context.getState<T>(_convertedBuildWhen);
    }
    return builder(context, state);
  }
}

class FutureStateBuilder<T> extends StatelessWidget {
  const FutureStateBuilder({super.key, required this.builder, this.buildWhen});

  final Widget Function(BuildContext, T state, bool isLoading) builder;
  final bool Function(T previous, T current)? buildWhen;

  bool _convertedBuildWhen(WrappedState previous, WrappedState current){
    return buildWhen!(previous.state, current.state);
  }

  @override
  Widget build(BuildContext context) {
    final T state;
    if(buildWhen == null){
      state = context.watch<T>();
    }
    else{
      state = context.getState<T>(_convertedBuildWhen);
    }
    return builder(context, state, context.isLoading<T>());
  }
}
import 'package:flutter/material.dart';
import 'state_extension.dart';

class StateBuilder<T> extends StatelessWidget {
  const StateBuilder({super.key, required this.builder});

  final Widget Function(BuildContext, T state) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.state<T>());
  }
}

class FutureStateBuilder<T> extends StatelessWidget {
  const FutureStateBuilder({super.key, required this.builder});

  final Widget Function(BuildContext, T state, bool isLoading) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.state<T>(), context.isLoading<T>());
  }
}
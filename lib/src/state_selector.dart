import 'package:flutter/material.dart';
import 'public_state_extensions.dart';

class StateSelector<T, R> extends StatelessWidget {
  const StateSelector({super.key, required this.selector, required this.builder});

  final R Function(T state) selector;
  final Widget Function(BuildContext, R selected) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.select<T, R>(selector));
  }
}
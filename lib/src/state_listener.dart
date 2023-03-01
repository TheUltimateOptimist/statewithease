import 'package:flutter/material.dart';
import 'private_state_extension.dart';

class StateListener<T> extends StatefulWidget {
  const StateListener({super.key, this.child, this.listenWhen, required this.listener});

  final void Function(BuildContext context, T state) listener;
  final bool Function(T previous, T current)? listenWhen;
  final Widget? child;

  @override
  State<StateListener<T>> createState() => _StateListenerState<T>();
}

class _StateListenerState<T> extends State<StateListener<T>> {
  bool _notRegistered = true;

  @override
  Widget build(BuildContext context) {
    if (_notRegistered) {
      context.getStateModel<T>(context.neverRebuild).registerListener(
        (previous, current) {
          if (previous.state == current.state) {
            return;
          }
          if (widget.listenWhen == null || widget.listenWhen!(previous.state, current.state)) {
            widget.listener(context, current.state);
          }
        },
      );
      _notRegistered = false;
    }
    return widget.child ?? Container();
  }
}

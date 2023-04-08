import 'dart:async';

class StateStream<T> {
  const StateStream({required this.stream, this.assign});
  final Stream<T Function(T)> stream;
  final void Function(T, StreamSubscription<T Function(T)>)? assign;
}
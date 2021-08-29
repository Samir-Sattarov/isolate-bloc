import 'dart:async';

/// Class that help communicate between [Isolate]s.
class IsolateMessenger extends Stream<Object> implements Sink<Object> {
  IsolateMessenger(this._fromIsolateStream, this._toIsolate) {
    _fromIsolateStream.listen((message) => _lastMessage = message);
  }

  final Stream<Object> _fromIsolateStream;
  final void Function(Object message) _toIsolate;
  Object? _lastMessage;

  /// Send messages to the [Isolate]
  @override
  void add(Object message) => _toIsolate(message);

  /// Receive messages from [Isolate]
  @override
  StreamSubscription<Object> listen(
    void Function(Object event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _behaviourSubject.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  Stream<Object> get _behaviourSubject async* {
    final lastMessage = _lastMessage;
    if (lastMessage != null) {
      yield lastMessage;
    }
    yield* _fromIsolateStream;
  }

  @override
  void close() {}
}

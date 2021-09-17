import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_bloc/isolate_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../blocs/simple_cubit.dart';

void main() {
  late UIIsolateManager uiIsolateManager;

  setUp(() {
    uiIsolateManager = _MockUIIsolateManager();

    UIIsolateManager.instance = uiIsolateManager;
  });

  group('test `createBloc`', () {
    test('test with initialized `UIIsolateManager`', () {
      when(() => uiIsolateManager.createBloc()).thenReturn(MockIsolateBlocWrapper<int>());
      createBloc<SimpleCubit, int>();

      verify(() => uiIsolateManager.createBloc()).called(1);
    });

    test('test with uninitialized `UIIsolateManager`', () {
      UIIsolateManager.instance = null;

      dynamic error;
      try {
        createBloc();
      } catch (e) {
        error = e;
      }

      expect(error, isA<UIIsolateManagerUnInitialized>());
      error.toString();
    });
  });

  test('test `initialize` function and recreate flag', () async {
    when(() => uiIsolateManager.dispose()).thenAnswer((invocation) => Future.value());

    await initialize(_initialize, recreate: true);

    verify(() => uiIsolateManager.dispose()).called(1);
  });

  test('test `initialize` function and recreate flag #2', () async {
    expect(initialize(_initialize, recreate: false), throwsA(isNotNull));
  });
}

void _initialize() {}

class MockIsolateBlocWrapper<T> extends Mock implements IsolateBlocWrapper<T> {}

class _MockUIIsolateManager extends Mock implements UIIsolateManager {}

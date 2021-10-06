import 'package:isolate_bloc/isolate_bloc.dart';
import 'package:isolate_bloc/src/common/isolate/isolate_factory/i_isolate_messenger.dart';
import 'package:isolate_bloc/src/common/isolate/manager/isolate_manager.dart';
import 'package:isolate_bloc/src/common/isolate/manager/ui_isolate_manager.dart';

/// {@template isolate_initializer}
/// Initializer which is used to create Isolate and initialize [UIIsolateManager]
/// and [IsolateManager].
/// {@endtemplate}
class IsolateInitializer {
  /// {@macro isolate_initializer}
  ///
  /// Takes user [initializer] function which will be launched in Isolate,
  /// [methodChannels] which is used to mock [MethodChannel] in Isolate
  /// and [isolateFactory] which is used to create new Isolate and initialize communication between it and UI Isolate
  Future<void> initialize(
    Initializer initializer,
    IIsolateFactory isolateFactory,
    MethodChannels methodChannels,
  ) async {
    // close current isolate
    await UIIsolateManager.instance?.dispose();

    final createResult = await isolateFactory.create(
      _isolatedBlocRunner,
      initializer,
      methodChannels,
    );

    final uiIsolateManager = UIIsolateManager(
      createResult,
    );

    // complete initialization
    await uiIsolateManager.initialize();
  }

  /// Runs in isolate to initialize [IsolateManager] and run [userInitializer]
  static Future<void> _isolatedBlocRunner(
    IIsolateMessenger messenger,
    Initializer userInitializer,
  ) async {
    final isolateManager = IsolateManager(
      messenger: messenger,
      userInitializer: userInitializer,
    );

    await isolateManager.initialize();
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksRepositoryHash() => r'30ca992b18a6d5f613ab6dd3562da2ecb95f9250';

/// See also [tasksRepository].
@ProviderFor(tasksRepository)
final tasksRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  tasksRepository,
  name: r'tasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TasksRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
String _$taskListStreamHash() => r'6370fbcba63e3180b1cb43313977ad76f7fa6879';

/// See also [taskListStream].
@ProviderFor(taskListStream)
final taskListStreamProvider =
    AutoDisposeStreamProvider<List<AppTask>>.internal(
  taskListStream,
  name: r'taskListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskListStreamRef = AutoDisposeStreamProviderRef<List<AppTask>>;
String _$taskListFutureHash() => r'41c8cc50058b90af9469af8744cbf5e972903eef';

/// See also [taskListFuture].
@ProviderFor(taskListFuture)
final taskListFutureProvider =
    AutoDisposeFutureProvider<List<AppTask>>.internal(
  taskListFuture,
  name: r'taskListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskListFutureRef = AutoDisposeFutureProviderRef<List<AppTask>>;
String _$taskHash() => r'2c2a8e3417164c59ac125b24824a9760520d06c0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [task].
@ProviderFor(task)
const taskProvider = TaskFamily();

/// See also [task].
class TaskFamily extends Family<AsyncValue<AppTask?>> {
  /// See also [task].
  const TaskFamily();

  /// See also [task].
  TaskProvider call(
    int id,
  ) {
    return TaskProvider(
      id,
    );
  }

  @override
  TaskProvider getProviderOverride(
    covariant TaskProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskProvider';
}

/// See also [task].
class TaskProvider extends AutoDisposeStreamProvider<AppTask?> {
  /// See also [task].
  TaskProvider(
    int id,
  ) : this._internal(
          (ref) => task(
            ref as TaskRef,
            id,
          ),
          from: taskProvider,
          name: r'taskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$taskHash,
          dependencies: TaskFamily._dependencies,
          allTransitiveDependencies: TaskFamily._allTransitiveDependencies,
          id: id,
        );

  TaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    Stream<AppTask?> Function(TaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskProvider._internal(
        (ref) => create(ref as TaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppTask?> createElement() {
    return _TaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskRef on AutoDisposeStreamProviderRef<AppTask?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TaskProviderElement extends AutoDisposeStreamProviderElement<AppTask?>
    with TaskRef {
  _TaskProviderElement(super.provider);

  @override
  int get id => (origin as TaskProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

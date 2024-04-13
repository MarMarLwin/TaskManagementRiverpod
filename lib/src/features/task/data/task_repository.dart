import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_management/src/constant/test_task.dart';
import 'package:task_management/src/features/task/domain/task.dart';
import 'package:task_management/src/utils/in_memory_store.dart';
part 'task_repository.g.dart';

class TaskRepository {
  final bool? addDelay;

  TaskRepository({this.addDelay});
  final List<AppTask> _tasks =
      InMemoryStore<List<AppTask>>(List.from(kTestTasks)).value;

  List<AppTask> getTasksList() {
    return _tasks;
  }

  AppTask? getTask(int id) {
    return _getTask(_tasks, id);
  }

  Future<List<AppTask>> fetchTasksList() async {
    return Future.value(kTestTasks);
  }

  Future<List<AppTask>> addTask(AppTask task) async {
    final List<AppTask> updated = List.from(kTestTasks)..add(task);
    return updated;
  }

  Stream<List<AppTask>> watchProductsList() {
    return Stream.value(_tasks);
  }

  Stream<AppTask?> watchTask(int id) {
    return watchProductsList().map((products) => _getTask(products, id));
  }

  static AppTask? _getTask(List<AppTask> tasks, int id) {
    try {
      return tasks.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

@riverpod
TaskRepository tasksRepository(TasksRepositoryRef ref) {
  return TaskRepository(addDelay: false);
}

@riverpod
Stream<List<AppTask>> taskListStream(TaskListStreamRef ref) {
  final taskRepository = ref.watch(tasksRepositoryProvider);
  return taskRepository.watchProductsList();
}

@riverpod
Future<List<AppTask>> taskListFuture(TaskListFutureRef ref) {
  final taskRepository = ref.watch(tasksRepositoryProvider);
  return taskRepository.fetchTasksList();
}

@riverpod
Stream<AppTask?> task(TaskRef ref, int id) {
  final taskRepository = ref.watch(tasksRepositoryProvider);
  return taskRepository.watchTask(id);
}

// import 'package:either_dart/either.dart';
// import 'package:task_management/src/features/task/domain/failures.dart';
// import 'package:task_management/src/features/task/domain/task.dart';
// import 'package:task_management/src/features/task/domain/unique_id.dart';

// abstract class TaskRepository {
//   Future<Either<Failure, List<AppTask>>> readTask(EntryId entryId);

//   Future<Either<Failure, bool>> createTask(AppTask task);
// }


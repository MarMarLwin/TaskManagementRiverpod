import 'package:task_management/src/features/task/domain/task.dart';

abstract class TaskDataSourceInterface {
  Future<AppTask> getTask({
    required String entryId,
  });

  Future<bool> createTask({required AppTask task});

  Future<AppTask> updateTask({
    required String entryId,
  });
}

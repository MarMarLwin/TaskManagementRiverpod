import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_management/src/features/authentication/data/auth_repository.dart';
import 'package:task_management/src/features/task/application/notification_service.dart';
import 'package:task_management/src/features/task/domain/task.dart';
import 'package:task_management/src/features/task/presentation/hive_controller.dart';
part 'task_service.g.dart';

enum ReminderRepeat {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}

class TaskService {
  TaskService(this.ref);
  final Ref ref;

  ReminderRepeat _reminderRepeat = ReminderRepeat.never;
  ReminderRepeat get reminderRepeat => _reminderRepeat;

  final NotificationService _notificationService = NotificationService();
  final TaskBox _taskBox = TaskBox();

  Future<List<AppTask>> readTasks() async {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;
    debugPrint('UUID =>${currentUser?.uid}');
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('${currentUser?.uid}/');
    final snapshot = await databaseReference.get();
    final List<AppTask> taskList = [];
    if (snapshot.exists) {
      await AsyncValue.guard(() async {
        final values = snapshot.value as List<Object?>;
        for (var value in values) {
          if (value != null) {
            AppTask task = AppTask.fromJson(value.toString());
            taskList.add(task);
          }
        }
        return taskList;
      });
    }
    return taskList;
  }

  Stream<AppTask> getTask(List<AppTask> tasks, int id) {
    final task = tasks.firstWhere((task) => task.id == id);

    return Stream.value(task);
  }

  Future<void> writeTask(AppTask task) async {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('${currentUser?.uid}/${task.id}');
    await AsyncValue.guard(() async {
      await databaseReference.set(task.toJson());
    });
  }

  Future<void> removeTask(AppTask task) async {
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('${currentUser?.uid}/${task.id}');

    await databaseReference.remove();
  }

  void setReminderRepeat(ReminderRepeat reminderRepeat) {
    _reminderRepeat = reminderRepeat;
  }

  void handleSavingReminder(
      {bool isEdit = false, required dynamic key, TaskModel? task}) {
    // creating reminder
    if (!isEdit) {
      _taskBox.insertReminder(task!);
      if (task.dueDate != null) {
        _notificationService.scheduleNotification(task);
      }
    }

    // updating reminder
    if (isEdit) {
      _taskBox.updateReminder(key, task!);
      if (task.dueDate != null) {
        _notificationService.scheduleNotification(task);
      }
    }
  }
}

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService(ref);
});

@riverpod
Future<List<AppTask>> taskListFuture(TaskListFutureRef ref) {
  final taskService = ref.watch(taskServiceProvider);
  return taskService.readTasks();
}

@riverpod
Stream<AppTask?> task(TaskRef ref, List<AppTask> tasks, int id) {
  final taskRepository = ref.watch(taskServiceProvider);

  return taskRepository.getTask(tasks, id);
}

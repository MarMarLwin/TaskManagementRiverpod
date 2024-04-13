// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/src/constant/test_task.dart';

import 'package:task_management/src/features/task/application/task_service.dart';
import 'package:task_management/src/features/task/domain/task.dart';

class TaskController extends StateNotifier<AsyncValue<List<AppTask>>> {
  TaskController(
    this.taskService,
  ) : super(AsyncData(kTestTasks));
  final TaskService taskService;

  Future<void> addTask(AppTask task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // final List<AppTask> taskList = await taskService.fetchTasks();
      final List<AppTask> updatedList = await taskService.addTasks(task);
      kTestTasks.add(task);

      debugPrint('Count ===> ${kTestTasks.length}');
      return kTestTasks; //TODO Change
    });
  }

  Future<void> updateTask(AppTask task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // final List<AppTask> taskList = await taskService.fetchTasks();
      final List<AppTask> updatedList = await taskService.addTasks(task);
      kTestTasks[kTestTasks.indexWhere((element) => element.id == task.id)] =
          task;

      return kTestTasks; //TODO Change
    });
  }

  Future<void> removeTask(AppTask task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // final List<AppTask> taskList = await taskService.fetchTasks();
      final List<AppTask> updatedList = await taskService.addTasks(task);
      kTestTasks.remove(task);

      debugPrint('Count ===> ${kTestTasks.length}');
      return kTestTasks; //TODO Change
    });
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, AsyncValue<List<AppTask>>>((ref) {
  return TaskController(ref.watch(taskServiceProvider));
});

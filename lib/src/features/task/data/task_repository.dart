// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:task_management/src/features/task/domain/task.dart';
// import 'package:task_management/src/features/task/presentation/task_controller.dart';
// part 'task_repository.g.dart';

// class TaskRepository {
//   final bool? addDelay;
//   final Ref? ref;

//   TaskRepository({this.addDelay, this.ref});
//   Future<List<AppTask>> readTasks() async {
//     DatabaseReference databaseReference =
//         FirebaseDatabase.instance.ref().child('tasks');
//     final snapshot = await databaseReference.get();
//     final List<AppTask> taskList = [];
//     if (snapshot.exists) {
//       await AsyncValue.guard(() async {
//         final values = snapshot.value as List<Object?>;
//         for (var value in values) {
//           if (value != null) {
//             AppTask task = AppTask.fromJson(value.toString());
//             taskList.add(task);
//           }
//         }
//         return taskList;
//       });
//     }
//     return taskList;
//   }

//   Stream<AppTask> getTask(List<AppTask> tasks, int id) {
//     final task = tasks.firstWhere((task) => task.id == id);

//     return Stream.value(task);
//   }

//   Future<void> writeTask(AppTask task) async {
//     DatabaseReference databaseReference =
//         FirebaseDatabase.instance.ref().child('tasks/${task.id}');
//     await AsyncValue.guard(() async {
//       await databaseReference.set(task.toJson());
//     });
//   }

//   Future<void> removeTask(AppTask task) async {
//     DatabaseReference databaseReference =
//         FirebaseDatabase.instance.ref().child('tasks/${task.id}');

//     await databaseReference.remove();
//   }
// }

// @riverpod
// TaskRepository tasksRepository(TasksRepositoryRef ref) {
//   return TaskRepository(addDelay: false);
// }

// @riverpod
// Stream<AppTask?> task(TaskRef ref, int id) {
//   final taskRepository = ref.watch(tasksRepositoryProvider);
//   final tasks = ref.watch(taskControllerProvider.notifier).state.value!;
//   return taskRepository.getTask(tasks, id);
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/src/features/authentication/data/auth_repository.dart';
import 'package:task_management/src/features/task/data/task_repository.dart';
import 'package:task_management/src/features/task/domain/task.dart';

class TaskService {
  TaskService(this.ref);
  final Ref ref;

  Future<List<AppTask>> fetchTasks() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return await ref.read(tasksRepositoryProvider).fetchTasksList();
    }
    return [];
  }

  Future<List<AppTask>> addTasks(AppTask task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return await ref.read(tasksRepositoryProvider).addTask(task);
    }
    return [];
  }
  // Future<void> _setCart(AppTask task) async {
  //   final user = ref.read(authRepositoryProvider).currentUser;
  //   if (user != null) {
  //     return await ref.read(tasksRepositoryProvider).setCart(user.uid, cart);
  //   }
  // }

  // Future<void> setItem(AppTeask item) async {
  //   final cart = await _fetchTasks();
  //   final updated = cart.setItem(item);
  //   _setCart(updated);
  // }

  // Future<void> addItem(Item item) async {
  //   final cart = await _fetchCart();
  //   final updated = cart.addItem(item);
  //   _setCart(updated);
  // }

  // Future<void> removeItemById(ProductID id) async {
  //   final cart = await _fetchCart();
  //   final updated = cart.removeItemById(id);
  //   await _setCart(updated);
  // }
}

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService(ref);
});

import 'package:hive/hive.dart';
import 'package:task_management/src/features/authentication/domain/app_user.dart';
import 'package:task_management/src/features/task/domain/task.dart';

class TaskBox {
  Box<TaskModel> box = Hive.box('tasks');

  void insertReminder(TaskModel dream) => box.add(dream);

  void updateReminder(dynamic key, TaskModel dream) => box.put(key, dream);

  void deleteReminder(int key) => box.delete(key);
}

class UserBox {
  Box<AppUser> box = Hive.box('users');

  void insertUser(AppUser dream) => box.add(dream);

  void updateUser(dynamic key, AppUser dream) => box.put(key, dream);

  void deleteUser(int key) => box.delete(key);
}

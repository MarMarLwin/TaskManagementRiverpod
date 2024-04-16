import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_management/src/common_widgets/async_value_widget.dart';
import 'package:task_management/src/common_widgets/empty_placeholder_widget.dart';
import 'package:task_management/src/constant/app_sizes.dart';
import 'package:task_management/src/features/task/application/notification_service.dart';
import 'package:task_management/src/features/task/domain/task.dart';
import 'package:task_management/src/features/task/presentation/hive_controller.dart';
import 'package:task_management/src/features/task/presentation/task_controller.dart';
import 'package:task_management/src/routing/app_router.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  NotificationService notificationService = NotificationService();
  TaskBox taskBox = TaskBox();

  bool isDone = false;

  @override
  void initState() {
    notificationService.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('My Tasks'),
        actions: [
          InkWell(
              child: const Padding(
                padding: EdgeInsets.all(Sizes.p12),
                child: Icon(Icons.account_circle),
              ),
              onTap: () {
                context.goNamed(AppRoute.account.name);
              })
        ],
      ),
      body: AsyncValueWidget<List<AppTask>>(
          value: taskList,
          data: (tasks) => tasks.isEmpty
              ? const EmptyPlaceholderWidget(message: 'No Tasks')
              : SingleChildScrollView(
                  child: SizedBox(
                    child: ReorderableListView.builder(
                      itemCount: tasks.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.2,
                            children: [
                              SlidableAction(
                                  onPressed: (context) {
                                    notificationService
                                        .cancelNotification(task.id);

                                    taskBox.deleteReminder(task.id);
                                    ref
                                        .watch(taskControllerProvider.notifier)
                                        .removeTask(task);
                                  },
                                  icon: Icons.close,
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  borderRadius: BorderRadius.circular(10))
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(AppRoute.newTask.name,
                                  pathParameters: {'id': task.id.toString()});
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(task.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(task.description),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer, size: 30),
                                        Text(DateFormat('dd/MM/yyyy hh:mm')
                                            .format(task.dueDate))
                                      ],
                                    )
                                  ],
                                ),
                                // trailing: Checkbox(onChanged: (value) {

                                // }, value: task.)
                              ),
                            ),
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex--;
                          }
                          debugPrint('$oldIndex => $newIndex');
                          final item = tasks.removeAt(oldIndex);

                          tasks.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(AppRoute.newTask.name, pathParameters: {'id': 'new'});
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
